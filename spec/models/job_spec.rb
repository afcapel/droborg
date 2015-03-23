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
      job.run

      expect(job.started_at).to be_present
      expect(job.finished_at).to be_present
      expect(job.status).to eq(Status::SUCCESS)
      expect(job.output).to match /bundle install/
    end
  end
end
