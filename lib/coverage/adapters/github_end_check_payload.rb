# frozen_string_literal: true

module Adapters
  class GithubEndCheckPayload
    def initialize(coverage_results:, coverage_detailed_results:)
      @coverage_results = coverage_results
      @coverage_detailed_results = coverage_detailed_results
    end

    def conclusion
      if @coverage_detailed_results.enabled? && !@coverage_detailed_results.passed?
        Configuration.on_fail_status
      else
        @coverage_results.passed? ? "success" : Configuration.on_fail_status
      end
    end

    def title
      if @coverage_detailed_results.enabled? && !@coverage_detailed_results.passed?
        "#{@coverage_detailed_results.total_files_failing_coverage} file(s) below minimum #{@coverage_detailed_results.minimum_coverage}% coverage"
      else
        "#{@coverage_results.covered_percent}% covered (minimum #{@coverage_results.minimum_coverage}%)"
      end
    end

    # TODO: removed (by #{@coverage_results.minimum_coverage_type})
    def summary
      detailed_summary = ""
      detailed_summary = "  * #{@coverage_detailed_results.minimum_coverage}% minimum coverage per file" if @coverage_detailed_results.enabled?

      <<~SUMMARY
        * #{@coverage_results.covered_percent}% covered
        * Current minimum coverage setting:
          * #{@coverage_results.minimum_coverage}% minimum coverage for suite
        #{detailed_summary}
      SUMMARY
    end

    def text
      if @coverage_detailed_results.enabled? && !@coverage_detailed_results.passed?
        build_detailed_markdown_results
      else
        "No details to show"
      end
    end

    private

    def build_detailed_markdown_results
      text_results = <<~TEXT
        ### The following files were below the minimum coverage
        | % | File |
        | ---- | -------- |
      TEXT

      if @coverage_detailed_results.size > 0
        @coverage_detailed_results.each do |result|
          text_results += "| #{result["covered_percent"].round(2)} | #{result["filename"].split("/").last(3).join("/")} |\n"
        end
      else
        text_results += "| 0 | There is no target files to cover in this PR |\n"
      end

      text_results
    end
  end
end
