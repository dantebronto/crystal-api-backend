class ErrorHandler
  def initialize(@env : HTTP::Server::Context)
  end

  def execute
    case @env.get("error.type")
    when "RecordNotFound"
      record_not_found
    when "JSON::ParseException"
      parser_exception
    when "PQ::PQError"
      db_error
    else
      { error: "An error has occurred" }.to_json
    end
  end

  private def db_error
    { error: "Database error" }.to_json
  end

  private def record_not_found
    @env.response.status_code = 404
    { error: "Record not found" }.to_json
  end

  private def parser_exception
    @env.response.status_code = 400
    { error: "Bad Request", message: "Unable to parse JSON payload" }.to_json
  end
end