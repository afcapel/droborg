module Github
  extend self


  def find_repo(repo_name)
    client.repository(repo_name)
  end

  def repos
    org.rels[:repos].get.data
  end

  def org
    @org ||= client.organization(ENV["GITHUB_ORG"])
  end

  def client
    @client ||= Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
  end
end
