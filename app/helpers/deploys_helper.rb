module DeploysHelper

  DEPLOY_ENVS = %w{int1 int2 int3 int4 int5 int6 int7 int8 int9 staging production}

  def deploy_env_select
    select("deploy", "name", DEPLOY_ENVS.collect {|e| [ e, e ] })
  end
end
