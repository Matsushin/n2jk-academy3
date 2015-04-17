Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Settings.github_app_id, Settings.github_app_secret, scope: 'user,repo'
end