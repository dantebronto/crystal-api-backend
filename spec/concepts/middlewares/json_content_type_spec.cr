require "../../spec_helper"

Spec2.describe JSONContentType do
  it "should reject all non-json requests" do
    mock = MockRequest.new("GET", "/")
    JSONContentType.new.call(mock.env)
    expect(mock.body.includes?("error")).to be_true
    expect(mock.response.status_code).to eq(422)
  end

  it "should force the content type to application/json" do
    mock = MockRequest.new("GET", "/")
    JSONContentType.new.call(mock.env)
    expect(mock.body.includes?("application/json")).to be_true
  end
end
