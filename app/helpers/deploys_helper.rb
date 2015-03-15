module DeploysHelper

  def deploy_env_select_for(project)
    environments = project.deploy_environments.collect { |e| [e.name, e.id] }
    select("deploy", "deploy_environment_id", environments)
  end
end
