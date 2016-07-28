require "spec"
require "spec2"

ENV["ENV"] = "test"

require "../config/environment"
require "../src/backend"

Kemal.config.add_handler Kemal::RouteHandler::INSTANCE

require "./mock_request"
require "./fixtures/**"

Spec2.doc
Spec2.random_order