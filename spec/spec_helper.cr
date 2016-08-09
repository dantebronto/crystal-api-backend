require "spec"
require "spec2"

ENV["ENV"] = "test"

require "../config/environment"
require "./mock_request"
require "./fixtures/**"

Spec2.doc
Spec2.random_order
