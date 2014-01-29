require 'spec_helper'

describe GitRepo do
  let(:project) { projects(:websocket_parser) }

  before :all do
    Dir.glob(Rails.root + '/tmp/projects/*').each { |dir| FileUtils.rm_f(dir) }
  end

  it "can initialize the git repo" do
    project.init_git_repo

    expect(File).to exist(Rails.root.to_s + "/tmp/projects/websocket_parser/websocket_parser.gemspec")
  end
end