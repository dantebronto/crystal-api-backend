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
    response.status_code = 403
    { error: "Forbidden" }.to_json
  end

  private def db_error
    { error: "Database error" }.to_json
  end

  private def record_not_found
    response.status_code = 404
    { error: "Not found" }.to_json
  end

  private def parser_exception
    response.status_code = 400
    { error: "Bad Request", messages: ["Unable to parse JSON payload"] }.to_json
  end
end