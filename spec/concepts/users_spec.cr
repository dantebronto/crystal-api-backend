require "../spec_helper"

Spec2.describe Users do

  describe "controller" do

    before { Query.run("BEGIN") }
    after  { Query.run("ROLLBACK") }

    let(admin) { Users::Fixture.admin }
    let(user) { Users::Fixture.user }
    let(other_user) { Users::Fixture.other_user }

    describe "index" do
      it "should show a list of users to the admin" do
        mock = MockRequest.new("GET", "/api/users").as_user(admin)
        result = Users::Controller.new(mock.env).index

        expect(JSON.parse(result)["users"].map {|x| x["name"] }
          .includes?(admin.name)).to be_true
        expect(mock.response.status_code).to eq(200)
      end

      it "should not show a list of users to an API user" do
        mock = MockRequest.new("GET", "/api/users").as_user(user)
        expect {
          Users::Controller.new(mock.env).index
        }.to raise_error(Unauthorized)
      end
    end

    describe "show" do
      it "should show a single user to the admin" do
        mock = MockRequest.new("GET", "/api/users/#{user.uuid}").as_user(admin)
        result = Users::Controller.new(mock.env).show

        expect(JSON.parse(result)["name"].to_s).to eq("user")
        expect(mock.response.status_code).to eq(200)
      end

      it "should not show a single user to users" do
        mock = MockRequest.new("GET", "/api/users/#{user.uuid}").as_user(user)
        expect {
          Users::Controller.new(mock.env).show
        }.to raise_error(Unauthorized)
      end
    end

    describe "create" do
      it "should validate a user signup presence" do
        mock = MockRequest.new("POST", "/api/users")
        result = JSON.parse(Users::Controller.new(mock.env).create)
        expect(result["error"]).not_to be_nil
        expect(result["messages"].includes?("password can't be blank")).to be_true
        expect(result["messages"].includes?("email can't be blank")).to be_true
        expect(result["messages"].includes?("name can't be blank")).to be_true
      end

      it "should validate password length" do
        body = %{{
          "name": "Bob",
          "email": "bob@example.com",
          "password": "12345"
        }}
        mock = MockRequest.new("POST", "/api/users", body).json
        result = JSON.parse(Users::Controller.new(mock.env).create)
        expect(result["messages"].first.to_s.includes?("password")).to be_true
      end

      it "should validate uniqueness" do
        body = %{{
          "name": "#{admin.name}",
          "email": "#{admin.email}",
          "password": "correct horse battery staple"
        }}
        mock = MockRequest.new("POST", "/api/users", body).json

        result = JSON.parse(Users::Controller.new(mock.env).create)
        expect(result["messages"].includes?("email has already been taken")).to be_true
        expect(result["messages"].includes?("name has already been taken")).to be_true
      end
    end

    describe "update" do
      it "should update a user if admin" do
        body = %{{
          "name": "user"
        }}
        mock = MockRequest.new("PUT", "/api/users/#{user.uuid}", body).
          json.as_user(admin)
        result = JSON.parse(Users::Controller.new(mock.env).update)
        expect(result["id"].to_s).to eq(user.uuid)
        expect(result["name"].to_s).to eq(user.name)
        epoch = result["updated_at"].to_s.to_i64
        expect(Time.utc_now.epoch_ms - epoch).to_be < 5000
      end

      it "should update a user if self" do
        body = %{{
          "email": "#{user.email}"
        }}
        mock = MockRequest.new("PUT", "/api/users/#{user.uuid}", body).
          json.as_user(user)
        result = JSON.parse(Users::Controller.new(mock.env).update)
        expect(Time.utc_now.epoch_ms - result["updated_at"].to_s.to_i64).to_be < 5000
      end

      it "shouldn't update user if not self or admin" do
        body = %{{
          "email": "#{user.email}"
        }}
        mock = MockRequest.new("PUT", "/api/users/#{admin.uuid}", body).
          json.as_user(user)
        expect {
          Users::Controller.new(mock.env).update
        }.to raise_error(Unauthorized)
      end
    end

    describe "delete" do
      it "should delete user if admin" do
        mock = MockRequest.new("DELETE", "/api/users/#{other_user.uuid}").
          json.as_user(admin)
        result = Users::Controller.new(mock.env).delete
        expect(mock.response.status_code).to eq(204)
      end

      it "should not delete user if not admin" do
        mock = MockRequest.new("DELETE", "/api/users/#{other_user.uuid}").
          json.as_user(user)
        expect {
          Users::Controller.new(mock.env).delete
        }.to raise_error(Unauthorized)
      end

      it "should allow a user to delete themselves" do
        mock = MockRequest.new("DELETE", "/api/users/#{other_user.uuid}").
          json.as_user(other_user)
        Users::Controller.new(mock.env).delete
        expect(mock.response.status_code).to eq(204)
      end

      it "should not allow admin to delete themselves" do
        mock = MockRequest.new("DELETE", "/api/users/#{admin.uuid}").
          json.as_user(admin)
        expect{
          Users::Controller.new(mock.env).delete
        }.to raise_error(Unauthorized)
      end
    end
  end
end
