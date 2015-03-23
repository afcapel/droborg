require "spec_helper"

feature "Launch a deploy" do

  let(:user)       { users(:admin) }
  let(:project)    { projects(:websocket_parser) }
  let(:production) { deploy_environments(:production) }
  let(:build)      { builds(:websocket_parser_build_3) }

  scenario "launch a deploy of websocket_parser to the staging environment", js: true do
    login_as(user)

    visit deploys_path

    within "#build_3" do
      select "Production", from: "deploy_deploy_environment_id"
      accepting_js_dialogs { click_button "Deploy" }
    end

    expect(page).to have_content "Deploy scheduled"

    last_deploy = Deploy.last
    expect(last_deploy.project).to eq project
    expect(last_deploy.deploy_environment).to eq production
    expect(last_deploy.build).to eq build
    expect(last_deploy.revision).to eq "3c258f9fa716dbda359b8aafe8ada155de20a2f0"
    expect(last_deploy.status).to eq Status::SCHEDULED
  end
end
