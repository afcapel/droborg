class Project < ActiveRecord::Base
  include EnvParsing

  has_many :deploy_scripts

  has_many :builds, dependent: :destroy
  has_many :deploys, dependent: :destroy

  has_many :build_tasks,  -> { order(:position) }, dependent: :destroy, class_name: "Build::Task"
  has_many :deploy_tasks, -> { order(:position) }, dependent: :destroy, class_name: "Deploy::Task"


  def self.create_from_github_repo(repo_name)
    repo = Github.find_repo(repo_name)

    create!(
      name: repo.name,
      git_url: repo.ssh_url
    )
  end

  def git_repo
    @git_repo ||= GitRepo.new(git_url, name)
  end
  alias_method :repo, :git_repo

  def github_url
    @github_url ||= git_url.sub('git@github.com:', 'https://github.com/').sub(/\.git$/, '')
  end

  def last_build
    builds.last
  end

  def setup
    git_repo.fetch
    update_attribute(:ready, true)
  end
end
