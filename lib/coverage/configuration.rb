# frozen_string_literal: true

# Provides simple interface for all configuration and environmental settings
class Configuration
  def self.coverage_path
    ENV["INPUT_COVERAGE_PATH"]
  end

  def self.coverage_json_path
    ENV["INPUT_COVERAGE_JSON_PATH"]
  end

  def self.minimum_suite_coverage
    ENV["INPUT_MINIMUM_SUITE_COVERAGE"]
  end

  # Requires simplecov-json results
  def self.minimum_file_coverage
    ENV["INPUT_MINIMUM_FILE_COVERAGE"]
  end

  def self.on_fail_status
    ENV["INPUT_ON_FAIL_STATUS"]
  end

  def self.github_token
    ENV["INPUT_GITHUB_TOKEN"]
  end

  def self.github_repo
    ENV["INPUT_GITHUB_REPOSITORY"] || ENV["GITHUB_REPOSITORY"]
  end

  def self.github_pr_id
    ENV["INPUT_GITHUB_PR_ID"]
  end

  def self.github_owner
    ENV["INPUT_GITHUB_OWNER"]
  end

  def self.github_sha
    Utils::RetrieveCommitSha.call
  end

  def self.debug_mode?
    ENV["INPUT_DEBUG_MODE"] == "true"
  end

  def self.check_job_name
    ENV["INPUT_CHECK_JOB_NAME"]
  end

  def self.github_comment_path
    # ref: https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28#create-an-issue-comment
    "#{github_owner}/#{github_repo}/issues/#{github_pr_id}/comments"
  end

  def self.github_api_url
    "https://api.github.com/repos"
  end
end
