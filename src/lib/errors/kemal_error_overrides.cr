# patch Kemal's error handler to add "error.class" to environment for generic exceptions

module Kemal
  # Kemal::CommonExceptionHandler handles all the exceptions including 404, custom errors and 500.
  class CommonExceptionHandler < HTTP::Handler
    def call(context)
      begin
        call_next(context)
      rescue Kemal::Exceptions::RouteNotFound
        call_exception_with_status_code(context, 404)
      rescue Kemal::Exceptions::CustomException
        call_exception_with_status_code(context, context.response.status_code)
      rescue ex : Exception
        context.set("error.type", ex.class.to_s)
        context.set("error.message", ex.message.to_s)
        Kemal.config.logger.write("Exception: #{ex.inspect_with_backtrace}\n")
        return call_exception_with_status_code(context, 500) if Kemal.config.error_handlers.has_key?(500)
        verbosity = Kemal.config.env == "production" ? false : true
        return render_500(context, ex.inspect_with_backtrace, verbosity)
      end
    end
  end
end

error 500 do |env|
  env.response.content_type = "application/json"
  ErrorHandler.new(env).execute
end

error 404 do |env|
  env.response.content_type = "application/json"
  { "error" => "not found" }.to_json
end