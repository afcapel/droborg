require 'spec_helper'

describe Build do
  context "launch build" do
    let(:project) { Project.where(name: "websocket_parser").first }
    let(:build)   { project.builds.first }

    it "schedules the first a job for the first task when it is run" do
      expect(RunJob).to receive(:perform_later).once.and_call_original

      expect { build.create_jobs }.to change(Job, :count).by(3)

      build.launch

      expect(Job.first.task).to eq(project.build_tasks.first)
      expect(enqueued_jobs.size).to eq(1)
    end

    it "schedules multiple jobs if they are parallelizable" do
      project.build_tasks.update_all parallelizable: true
      expect(RunJob).to receive(:perform_later).exactly(3).times.and_call_original

      expect { build.create_jobs }.to change(Job, :count).by(3)

      build.launch

      jobs = Build::Job.where(build_id: build.id)

      expect(jobs[0].task).to eq(project.build_tasks[0])
      expect(jobs[1].task).to eq(project.build_tasks[1])
      expect(jobs[2].task).to eq(project.build_tasks[2])

      expect(enqueued_jobs.size).to eq(3)
    end
  end
end
