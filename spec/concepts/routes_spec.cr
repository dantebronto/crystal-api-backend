require "../spec_helper"

Spec2.describe Routes do

  describe "controller" do

    let(user) { Users::Fixture.user }

    before { Query.run("BEGIN") }
    after  { Query.run("ROLLBACK") }

    describe "index" do
      it "should show a list of routes" do
        mock = MockRequest.new("GET", "/api/routes").as_user(user).json
        routes = JSON.parse(Routes::Controller.new(mock.env).index)["routes"]
        expect(
          routes.map {|x| x["verb"].to_s }.uniq.sort_by {|x| x.to_s }
        ).to eq(["DELETE", "GET", "POST", "PUT"])
      end
    end
  end
end
