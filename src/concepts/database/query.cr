alias InsertType = String | Time | Bool | Nil

class Query
  def self.select(string = "*")
    self.new.select(string)
  end

  def self.from(string = "")
    self.new.from(string)
  end

  def self.insert(values)
    self.new.insert(values)
  end

  def self.insert(table, values)
    self.new.insert(table, values)
  end

  def self.update(values)
    self.new.update(values)
  end

  def self.update(table, values)
    self.new.update(table, values)
  end

  def self.delete
    self.new.delete
  end

  def self.run(string)
    self.new.run(string)
  end

  def self.run(string, params)
    self.new.run(string, params)
  end

  def initialize
    @select = "*"
    @wheres = [] of String
    @params = [] of InsertType
    @limit = ""
    @table = ""
    @from = ""
    @order = ""
    @values = {} of String => InsertType
    @insert_keys = ""
    @insert_values = ""
    @count_called = false
    @delete_called = false
    @update_string = ""
  end

  def into(string = "")
    @table = string
    self
  end

  def select(string = "*")
    @select = string
    self
  end

  def from(string = "table_name")
    @from = "FROM #{string}"
    self
  end

  def insert(values)
    @values = values
    @insert_keys = values.keys.join(", ")

    value_strings = [] of String
    @values.values.each { |a| value_strings << "?" }
    @insert_values = value_strings.join(", ")

    self
  end

  def insert(table, values)
    @table = table
    insert(values)
  end

  def update(values)
    @values = values

    update_clause = [] of String
    @values.each do |key, value|
      update_clause << "#{key} = ?"
    end

    @update_string = "SET #{update_clause.join(", ")}"

    self
  end

  def update(table, values)
    @table = table
    update(values)
    self
  end

  def delete
    @delete_called = true
    self
  end

  def where(string : String)
    @wheres.push(string)
    self
  end

  def where(string : String, param : InsertType)
    @wheres.push(string)
    @params.push(param)
    self
  end

  def order(string)
    @order = string
    self
  end

  def table(string)
    @table = string
    self
  end

  def where(string : String, ara : Array(String))
    if string =~ / IN | in /
      expanded = [] of String
      ara.each { |a| expanded << "?" }
      string = string.sub("?", expanded.join(", "))
    end
    @wheres.push(string)
    ara.each { |a| @params.push(a) }
    self
  end

  def limit(number = 1)
    @limit = number.to_s
    self
  end

  def order(string)
    @order = "ORDER BY #{string}"
    self
  end

  def count
    @count_called = true

    res = if @params.size > 0
            run(build_select, @params)
          else
            run(build_select)
          end

    res.first["count"]
  end

  def execute
    return execute_insert unless @insert_keys == ""
    return execute_update unless @update_string == ""
    execute_select
  end

  def run(string)
    start = Time.now

    conn = DB.checkout
    rows = conn.exec(string)
    DB.checkin(conn)

    db_log(string, elapsed_text(Time.new - start))
    rows.to_hash
  end

  def run(string, params)
    start = Time.now

    string = handle_positional_args(string)

    conn = DB.checkout
    rows = conn.exec(string, params)
    DB.checkin(conn)

    db_log(string, elapsed_text(Time.new - start), params)
    rows.to_hash
  end

  private def select_clause
    if @count_called
      "SELECT COUNT(#{@select})"
    elsif @delete_called
      "DELETE"
    else
      "SELECT #{@select}"
    end
  end

  def where_clauses
    return "" if @wheres.size == 0
    "WHERE " + @wheres.join(" AND ")
  end

  def build_insert
    q = [] of String
    q.push("INSERT INTO #{@table} (#{@insert_keys})")
    q.push("VALUES (#{@insert_values})")
    q.push("RETURNING *")
    q.join(" ")
  end

  private def execute_insert
    run(build_insert, @values.values)
  end

  def build_update
    q = [] of String
    q.push("UPDATE #{@table}")
    q.push(@update_string)
    q.push(where_clauses)
    q.push("RETURNING *")
    q.flatten.reject { |x| x == "" }.join(" ")
  end

  private def execute_update
    run(build_update, @values.values + @params)
  end

  def build_select
    [
      select_clause,
      @from,
      where_clauses,
      @order,
      @limit == "" ? "" : "LIMIT #{@limit}",
    ].flatten.reject { |x| x == "" }.join(" ")
  end

  def build_delete
    build_select
  end

  private def execute_select
    if @params.size > 0
      run(build_select, @params)
    else
      run(build_select)
    end
  end

  # convert ?, ?, ?... to $1, $2, $3...
  private def handle_positional_args(string)
    query = ""
    chunks = string.split("?")
    chunks.each_with_index do |chunk, i|
      query += chunk
      query += "$#{i + 1}" if i != chunks.size - 1
    end
    query
  end

  private def db_log(string, elapsed)
    return unless ENV["LOG_DB"] == "true"
    puts "\e[36m#{"%7.7s" % elapsed} \e[34m#{string}\e[0m"
  end

  private def db_log(string, elapsed, params)
    return unless ENV["LOG_DB"] == "true"
    params.each do |param|
      string = string.sub(/\$\d+/, "'#{param}'")
    end
    db_log(string, elapsed)
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
