module RepositoryHelpers
  def query(string)
    start = Time.now
    db_log(string)

    conn = DB.checkout
    rows = conn.exec(string)
    DB.checkin(conn)

    db_log(elapsed_text(Time.new - start))
    rows.to_hash
  end

  def query(string, params)
    start = Time.now

    string = handle_positional_args(string)
    db_log(string)
    db_log(params.inspect)

    conn = DB.checkout
    rows = conn.exec(string, params)
    DB.checkin(conn)

    db_log(elapsed_text(Time.new - start))
    rows.to_hash
  end

  # convert $?, $?, $?... to $1, $2, $3...
  def handle_positional_args(string)
    query = ""
    chunks = string.split("$?")
    chunks.each_with_index do |chunk, i|
      query += chunk
      query += "$#{i+1}" if i != chunks.size - 1
    end
    query
  end

  private def db_log(string)
    puts "\e[35m#{string}\e[0m"
  end

  private def elapsed_text(elapsed)
    minutes = elapsed.total_minutes
    return "#{minutes.round(2)}m" if minutes >= 1

    seconds = elapsed.total_seconds
    return "#{seconds.round(2)}s" if seconds >= 1

    millis = elapsed.total_milliseconds
    return "#{millis.round(2)}ms" if millis >= 1

    "#{(millis * 1000).round(2)}µs"
  end
end