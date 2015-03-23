class Workspace

  attr_accessor :project, :revision
  delegate :git_repo, to: :project

  def self.root_path
    @root_path ||= FileUtils.mkdir_p(Rails.root + 'tmp/workspaces').first
  end

  def initialize(project, revision)
    @project, @revision = project, revision
  end

  def commit
    project.repo.commit(revision)
  end

  def setup!
    FileUtils.rm_rf(path)
    setup
  end

  def setup
    return if File.exist?(path)

    project.git_repo.init unless File.exist?(git_repo.path)
    git_repo.fetch
    git_repo.clone_revision(Workspace.root_path, revision)
  end

  def path
    "#{Workspace.root_path}/#{revision}"
  end
end
