require 'spec_helper'

describe "beta_access_requests/index" do
  before(:each) do
    assign(:beta_access_requests, [
      stub_model(BetaAccessRequest,
        :email => "Email"
      ),
      stub_model(BetaAccessRequest,
        :email => "Email"
      )
    ])
  end

  it "renders a list of beta_access_requests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
