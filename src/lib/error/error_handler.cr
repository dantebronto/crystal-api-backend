class ErrorHandler < ApplicationController
  def execute
    case @env.get("error.type")
    when "RecordNotFound"
      record_not_found
    when "JSON::ParseException"
      parser_exception
    when "PQ::PQError"
      db_error
    when "Unauthorized"
      unauthorized
    else
      { error: "An error has occurred" }.to_json
    end
  end

  private def unauthorized
    error({ error: "Forbidden" }, status: 403)
  end

  private def db_error
    error({ error: "Database error" }, status: 500)
  end

  private def record_not_found
    error({ error: "Not found" }, status: 404)
  end

  private def parser_exception
    error({
      error: "Bad Request",
      messages: ["Unable to parse JSON payload"],
    }, status: 400)
  end
end