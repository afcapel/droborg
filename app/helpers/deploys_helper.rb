module DeploysHelper

  DEPLOY_ENVS = %w{int1 int2 int3 int4 int5 int6 int7 int8 int9 staging production}

  def deploy_env_select_for(project)
    env_names = project.deploy_environments
    select("deploy", "name", env_names)
  end
end
