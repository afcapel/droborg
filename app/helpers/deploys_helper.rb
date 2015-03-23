module DeploysHelper

  def deploy_env_select_for(project)
    environments = project.deploy_environments.collect { |e| [e.name, e.id] }
    select("deploy", "deploy_environment_id", environments)
  end

  def deploy_poll_tag(&block)
    attributes = { id: 'deploy', class: 'deploy' }

    unless @deploy.finished?
      attributes.merge!(data: { 'poll-url' => request.path } )
    end

    content_tag :article, attributes, &block
  end
end
