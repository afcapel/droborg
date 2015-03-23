module FeatureHelper

  def login_as(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: "github",
      uid: user.github_uid,
      info: {
        name: user.name,
        email: user.email,
        image: user.avatar_url,
        nickname: user.github_username,
      },
      credentials: {
        token: user.github_token
      }
    })

    visit "/auth/github/callback"
  end

  def accepting_js_dialogs(&block)
    page.evaluate_script <<-JS
      window.original_confirm = window.confirm;
      window.confirm = function() { return true; };
    JS

    block.call

    page.evaluate_script <<-JS
      window.confirm = window.original_confirm;
    JS
  end
end
