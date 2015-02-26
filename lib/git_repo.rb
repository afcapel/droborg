class GitRepo

  attr_reader :git_url, :name, :remote_origin

  def self.root_path
    @root_path ||= FileUtils.mkdir_p(Rails.root + 'tmp/repos/').first
  end

  def initialize(git_url, name)
    @git_url = git_url
    @name    = name
  end

  def path
    @path ||= GitRepo.root_path + name.parameterize
  end

  def commit(revision)
    git.gcommit(revision)
  end

  def commits(branch = 'master', count = 5, skip = 0)
    git.log(count).object(branch).skip(skip).collect do |git_commit|
      Commit.new(git_commit)
    end
  end

  def commit_count(branch = 'master')
    git.log.object(branch).to_a.size
  end

  def fetch
    `cd #{path} && git fetch`
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

  def clone_revision(dir, revision)
    fetch

    revision_path = "#{dir}/#{revision}"

    FileUtils.mkdir_p(revision_path)

    `git clone --local #{path} #{revision_path}`
    `cd #{revision_path} && git fetch -q origin && git fetch --tags -q origin && git reset -q --hard #{revision} && git clean -q -d -x -f`
  end

  def init
    @git = Git.init(path)

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
