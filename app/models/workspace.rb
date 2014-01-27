require 'open3'

class Workspace
  include GitRepo

  attr_accessor :project, :revision

  def initialize(project, revision)
    @project, @revision = project, revision
  end

  def commit
    git.gcommit(revision)
  end

  def setup
  end

  def execute(command, env = {}, &block)
    Open3.popen2e(env, "cd #{path} && #{command}", spawn_options, &block)
  end

  def repo_name
    project.repo_name
  end

  def path
    @path ||= File.expand_path(project.path_to_repo)
  end

  def spawn_options
    {
      chdir: path,
      unsetenv_others: true
    }
  end
end