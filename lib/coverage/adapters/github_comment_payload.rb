# frozen_string_literal: true

module Adapters
  class GithubCommentPayload
    def initialize(coverage_results:, coverage_detailed_results:, target_files:)
      @coverage_results = coverage_results
      @coverage_detailed_results = coverage_detailed_results
      @target_files = target_files
    end

    def body
      <<~COMMENT_BODY
      ## Overall (for all source code of ec_force)
      #{title}
      #{summary}

      ## For this pull request only
      #{build_detailed_markdown_results}
      COMMENT_BODY
    end

    private

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
      detailed_summary = "  * #{@coverage_detailed_results.minimum_coverage} minimum coverage per file" if @coverage_detailed_results.enabled?

      <<~SUMMARY
        * #{@coverage_results.covered_percent}% covered
        * Current setting for minimum coverage
          * #{@coverage_results.minimum_coverage}% minimum coverage for suite
        #{detailed_summary}
      SUMMARY
    end

    def build_detailed_markdown_results
      return "" if @target_files.size == 0

      target_files_hash = {}
      @target_files.each do |file_name|
        target_files_hash[normalize_file_name(file_name)] = true
      end

      text_results = <<~TEXT
        ### Failed because the following files were below the minimum coverage
        | % | File |
        | ---- | -------- |
      TEXT

      is_having_covered_files = false
      @coverage_detailed_results.each do |result|
        next unless target_files_hash.include?(normalize_file_name(result["filename"]))
        is_having_covered_files = true
        text_results += "| #{result["covered_percent"].round(2)} | #{result["filename"]} |\n"
      end

      return "There is no target files to cover in this PR" unless is_having_covered_files

      text_results
    end

    def normalize_file_name(file_name)
      file_name.split("/").last(3).join("/")
    end
  end
end
