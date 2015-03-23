require "open3"

class ShellCommand

  attr_reader :command, :path, :env

  def initialize(command, path, env = {})
    @command, @path = command, path
    @env = child_env.merge(env)
  end

  def run(&on_output)
    Bundler.with_clean_env do
      Open3.popen2e(env, command, spawn_options) do |stdin, stdout_and_stderr, wait_thread|
        while line = stdout_and_stderr.gets
          on_output.call(line)
        end

        exit_status = wait_thread.value
        exit_status
      end
    end
  end

  private

  def spawn_options
    {
      chdir: path
    }
  end

  def child_env
    child_env = ENV.to_h

    clean_rbenv_variables(child_env) if File.exist? "#{path}/.ruby-version"

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
