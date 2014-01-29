require 'spec_helper'

describe Workspace do
  let(:project)   { projects(:websocket_parser) }
  let(:revision)  { '5571f8e058ec2be40a05ea9dad935904464577fc' }
  let(:workspace) { Workspace.new(project, revision) }

  context "workspace setup" do
    before :each do
      Dir.glob(Rails.root + 'tmp/workspaces/*').each { |dir| FileUtils.rm_rf(dir) }
    end

    before :each do
      workspace.setup
    end

    it "creates its working dir" do
      expect(File).to exist(Rails.root.to_s + "/tmp/workspaces/#{revision}")
    end

    it "checkouts repo files into the working dir" do
      files_in_workspace = Dir.glob("#{workspace.path}/*").collect { |f| File.basename(f) }
      expect(files_in_workspace).to include 'websocket_parser.gemspec'
    end
  end
end