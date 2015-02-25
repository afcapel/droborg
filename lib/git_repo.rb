class GitRepo

  attr_reader :git_url, :name, :remote_origin

  def self.root_path
    @root_path ||= FileUtils.mkdir_p(Rails.root + 'tmp/repos/').first
  end

  def initialize(git_url, name)
    @git_url = git_url
    @name    = name
  end

  def path_to_repo
    @path_to_repo ||= FileUtils.mkdir_p(GitRepo.root_path + name.parameterize).first
  end

  def commits(branch = 'master', count = 5, skip = 0)
    git.log(count).object(branch).skip(skip).to_a
  end

  def commit_count(branch = 'master')
    git.log.object(branch).to_a.size
  end

  def fetch
    git.fetch(git_url)
  end

  def branches
    git.branches.remote.collect { |b| [b.name, "#{b.remote}/#{b.name}"] }
  end

  def github?
    git_url.start_with?('git@github.com:')
  end

  def git
    @git ||= init
  end

  def clone_revision(path, revision = 'master')
    FileUtils.mkdir_p(path)
    git_fetch
    clone = Git.clone("file://#{path_to_repo}", revision, :path => path)
    clone.reset_hard(revision)
  end

  def init
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
