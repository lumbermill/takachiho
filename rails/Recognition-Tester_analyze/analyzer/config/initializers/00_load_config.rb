APP_CONFIG = YAML.load_file("#{Rails.root}/config/settings.yml")[Rails.env]
APP_CONFIG["train_image_dir"] = APP_CONFIG["data_home"] + "/train-image"
APP_CONFIG["query_image_dir"] = APP_CONFIG["data_home"] + "/query-image"
APP_CONFIG["result_json"] = APP_CONFIG["data_home"] + "/result-json"
