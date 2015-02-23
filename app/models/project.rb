class Project < ActiveRecord::Base
  include GitRepo

  has_many :tasks, dependent: :destroy
  has_many :builds, dependent: :destroy

  def self.create_from_github_repo(repo_name)
    repo = Github.find_repo(repo_name)

    create!(
      name: repo.name,
      git_url: repo.ssh_url
    )
  end

  def repo_name
    name.parameterize
  end

  def github?
    git_url.start_with?('git@github.com:')
  end

  def last_build
    builds.last
  end

  def setup
    init_git_repo
    update_attribute(:ready, true)
  end
  handle_asynchronously :setup

  def env_hash
    @env_hash ||= Hash.new.tap do |h|
      next if env.blank?

      env.lines.each do |line|
        key, val = line.split('=')
        h[key.strip] = val.strip if val.present?
      end
    end
  end

  def github_url
    return nil unless github?

    @github_url ||= git_url.sub('git@github.com:', 'https://github.com/').sub(/\.git$/, '')
  end
end
