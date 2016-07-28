require "../spec_helper"

Spec2.describe Sessions do

  describe "controller" do

    before { Query.run("BEGIN") }
    after  { Query.run("ROLLBACK") }

    let(admin) { Users::Fixture.admin }
    let(user) { Users::Fixture.user }

    describe "create" do
      it "should validate signin" do
        mock = MockRequest.new("POST", "/api/sessions").as_user(admin).json
        result = JSON.parse(Sessions::Controller.new(mock.env).create)
        expect(result["error"].to_s).to eq("Not authenticated")
        expect(result["messages"].includes?("email can't be blank")).to be_true
        expect(result["messages"].includes?("password can't be blank")).to be_true
        expect(mock.response.status_code).to eq(401)
      end

      it "should allow signin and return a jwt token encoded with the user id" do
        body = %{{
          "email": "#{user.email}"
          "password": "changeme"
        }}
        mock = MockRequest.new("POST", "/api/sessions", body).as_user(user).json
        result = JSON.parse(Sessions::Controller.new(mock.env).create)
        token = JWT.decode(result["token"].to_s, ENV["SESSION_SECRET"], "HS256")
        expect(token.first["uid"]).to eq(user.id)
      end
    end
  end
end
