require 'open3'

class Workspace
  include GitRepo

  attr_accessor :project, :revision

  def self.root_path
    @root_path ||= FileUtils.mkdir_p(Rails.root + 'tmp/workspaces').first
  end

  def initialize(project, revision)
    @project, @revision = project, revision
  end

  def commit
    git.gcommit(revision)
  end

  def execute(command, env = {}, &block)
    Bundler.with_clean_env do
      env = child_env.merge(env)
      Open3.popen2e(env, command, spawn_options, &block)
    end
  end

  def setup!
    FileUtils.rm_rf(path)
    setup
  end

  def setup
    project.init_git_repo unless File.exist?(path_to_repo)
    clone_repo(Workspace.root_path, revision) unless File.exist?(path)
  end

  def repo_name
    project.repo_name
  end

  def path
    "#{Workspace.root_path}/#{revision}"
  end

  def spawn_options
    {
      chdir: path
    }
  end

  def child_env
    child_env = ENV.to_h

    clean_rbenv_variables(child_env) if File.exist? "#{path}/.ruby-version"

    child_env.merge!(project.env_hash)

    child_env
  end

  def clean_rbenv_variables(child_env)
    child_env['RBENV_VERSION'] = File.read("#{path}/.ruby-version").strip

    paths = ENV['PATH'].split(':').reject do |p|
      p.include? "#{ENV['RBENV_ROOT']}/versions"
    end

    child_env['PATH'] = paths.join(':')
  end
end