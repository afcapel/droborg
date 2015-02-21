module GitRepo
  extend ActiveSupport::Concern

  included do
    attr_reader :remote_origin
  end

  def self.root_path
    @root_path ||= FileUtils.mkdir_p(Rails.root + 'tmp/projects/').first
  end

  def path_to_repo
    @path_to_repo ||= FileUtils.mkdir_p(GitRepo.root_path + repo_name.parameterize).first
  end

  def commits(branch = 'master', count = 5, skip = 0)
    git.log(count).object(branch).skip(skip).to_a
  end

  def commit_count(branch = 'master')
    git.log.object(branch).to_a.size
  end

  def git_fetch
    git.fetch(git_url)
  end

  def branches
    git.branches.remote.collect { |b| [b.name, "#{b.remote}/#{b.name}"] }
  end

  def git
    @git ||= init_git_repo
  end

  def clone_revision(path, revision = 'master')
    FileUtils.mkdir_p(path)
    git_fetch
    clone = Git.clone("file://#{path_to_repo}", revision, :path => path)
    clone.reset_hard(revision)
  end

  def init_git_repo
    @git = Git.init(path_to_repo)

    unless git_remote_names.include? 'origin'
      @remote_origin = @git.add_remote('origin', git_url)
      @git.fetch
      @git.checkout('master')
    end

    @git
  end

  def git_remote_names
    @git.remotes.collect(&:name)
  end
end
