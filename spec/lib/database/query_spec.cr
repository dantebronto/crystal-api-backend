require "../../spec_helper"

Spec2.describe "Query building" do
  describe "select" do
    it "should allow select queries" do
      query = Query.select("*").from("users").build_select
      expect(query).to eq("SELECT * FROM users")
    end

    it "should allow you to leave off the select part of the query" do
      query = Query.from("users").build_select
      expect(query).to eq("SELECT * FROM users")
    end

    it "should allow where clauses" do
      query = Query.
        select("name, uuid").
        from("users").
        where("name = $?", "bob").
        where("uuid = $?", "1234").
        build_select

      expect(query).to eq("SELECT name, uuid FROM users WHERE name = $? AND uuid = $?")
    end

    it "should allow limit clauses" do
      query = Query.select("email").from("users").limit(1).build_select
      expect(query).to eq("SELECT email FROM users LIMIT 1")
    end
  end

  describe "delete" do
    it "should allow delete queries" do
      query = Query.delete.from("users").build_delete
      expect(query).to eq("DELETE FROM users")
    end

    it "should allow where clauses" do
      query = Query.delete.from("users").where("id = $?", "1234").build_delete
      expect(query).to eq("DELETE FROM users WHERE id = $?")
    end
  end

  describe "insert" do
    it "should allow insert from a hash" do
      query = Query.insert({ "name" => "Bob", "email" => "bob@example.com" } of String => InsertType).into("users").build_insert
      expect(query).to eq("INSERT INTO users (name, email) VALUES ($?, $?) RETURNING *")
    end
  end

  describe "update" do
    it "should allow update from a hash" do
      query = Query.update({ "name" => "Bob", "email" => "bob@example.com" } of String => InsertType).table("users").build_update
      expect(query).to eq("UPDATE users SET name = $?, email = $? RETURNING *")
    end

    it "should allow where clauses" do
      query = Query.update({ "name" => "Bob"} of String => InsertType).
        where("id = $?", "123").
        table("users").build_update
      expect(query).to eq("UPDATE users SET name = $? WHERE id = $? RETURNING *")
    end

    it "should allow passing of table into update method" do
      query = Query.update("users", { "name" => "Bob"} of String => InsertType).build_update
      expect(query).to eq("UPDATE users SET name = $? RETURNING *")
    end
  end
end
