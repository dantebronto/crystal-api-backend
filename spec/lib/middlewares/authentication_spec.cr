require "../../spec_helper"

Spec2.describe Authentication do
  it "should reject all requests that aren't to sessions#create or users#create" do
    mock = MockRequest.new("GET", "/").json
    Authentication.new.call(mock.env)
    expect(mock.response.status_code).to eq(401)
    expect(mock.response.headers["Content-Type"]).to eq("application/json")

    mock = MockRequest.new("GET", "/api/users")
    Authentication.new.call(mock.env)
    expect(mock.response.status_code).to eq(401)

    mock = MockRequest.new("POST", "/api/users")
    Authentication.new.call(mock.env)
    expect(mock.response.status_code).not_to eq(401)

    mock = MockRequest.new("POST", "/api/sessions")
    Authentication.new.call(mock.env)
    expect(mock.response.status_code).not_to eq(401)
  end

  it "should reject requests with an auth header not found error" do
    mock = MockRequest.new("GET", "/api/users").json
    Authentication.new.call(mock.env)
    expect(mock.response.status_code).to eq(401)
    expect(mock.body.includes?("header not found")).to be_true
  end

  it "should reject requests with an invalid auth header" do
    mock = MockRequest.new("GET", "/api/users").
      header("Authorization", "Bearer fake-token").
      json

    Authentication.new.call(mock.env)
    expect(mock.response.status_code).to eq(401)
    expect(mock.body.includes?("Verification error")).to be_true
  end

  it "should parse a valid token" do
    payload = { "uid" => 1, "nonce" => Time.now.epoch.to_s }
    token = JWT.encode(payload, ENV["SESSION_SECRET"], "HS256")

    mock = MockRequest.new("GET", "/api/users").
      header("Authorization", "Bearer #{token}")

    Authentication.new.call(mock.env)
    expect(mock.response.status_code).not_to eq(401)
  end
end