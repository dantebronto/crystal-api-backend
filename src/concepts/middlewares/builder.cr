# add middlewares here so we can control the order
Kemal.config.add_handler JSONContentType.new
Kemal.config.add_handler Authentication.new
