require 'spec_helper'

describe Deploy do

  let(:build) { builds(:websocket_parser_build_3) }
  let(:user) { users(:admin) }
  let(:production) { deploy_environments(:production) }

  let(:deploy) { Deploy.create!(build: build, user: user, deploy_environment: production) }

  it "executes the deploy command in the workspace when it is launched" do
    deploy.launch

    expect(deploy.started_at).to be_present
    expect(deploy.finished_at).to be_present
    expect(deploy.status).to eq(Status::SUCCESS)
    expect(deploy.output).to eq("$ echo \"cap production deploy\"\n\ncap production deploy\n")
  end

  it "has a failed status if the command failed" do
    expect(deploy.command).to receive(:run) { double(:success? => false) }

    deploy.launch

    expect(deploy.started_at).to be_present
    expect(deploy.finished_at).to be_blank
    expect(deploy.status).to eq(Status::FAILED)
  end
end
