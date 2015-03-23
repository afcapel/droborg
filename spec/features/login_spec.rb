require "spec_helper"

feature "Login" do

  scenario "login with valid credentials" do
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: "github",
      uid: "12345",
      info: {
        name: "Test User",
        email: "test@example.com",
        image: "http://example.com/avatar.png",
        nickname: "testuser",
      },
      credentials: {
        token: "test_token"
      }
    )

    expect { visit "/auth/github/callback" }.to change{ User.count }.by(1)
    expect(page).to have_content("Signed in.")

    last_user = User.last

    expect(last_user.name).to eq("Test User")
    expect(last_user.email).to eq("test@example.com")
    expect(last_user.avatar_url).to eq("http://example.com/avatar.png")
    expect(last_user.github_uid).to eq(12345)
    expect(last_user.github_username).to eq("testuser")
    expect(last_user.github_token).to eq("test_token")
  end

  scenario "try to login with invalid credentials" do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials

    expect { visit "/auth/github/callback" }.not_to change{ User.count }

    expect(page).to have_content("Not authorized")
  end
end
