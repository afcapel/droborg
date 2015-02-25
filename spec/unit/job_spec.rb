require 'spec_helper'

describe Job do
  include ActiveJob::TestHelper

  context "run job" do
    let(:project) { Project.where(name: "websocket_parser").first }
    let(:build)   { project.builds.first }
    let(:job) do
      build.create_jobs
      build.jobs.first
    end

    it "executes the task command in the workspace" do
      expect(job).to receive(:execute).with("bundle install")
      job.run
    end
  end
end
