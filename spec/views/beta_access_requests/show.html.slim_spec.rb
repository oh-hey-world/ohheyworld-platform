require 'spec_helper'

describe "beta_access_requests/show" do
  before(:each) do
    @beta_access_request = assign(:beta_access_request, stub_model(BetaAccessRequest,
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
  end
end
