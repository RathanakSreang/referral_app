Swagger::Docs::Config.base_api_controller = ActionController::API
Swagger::Docs::Config.register_apis({
  '1.0' => {
    api_file_path: 'public',
    base_path: Settings.api_base_path,
    clean_directory: true,
    base_api_controller: ActionController::API,
    attributes: {
      info: {
        title: "Referral  API",
        description: "Referral API"
      }
    }
  }
})
