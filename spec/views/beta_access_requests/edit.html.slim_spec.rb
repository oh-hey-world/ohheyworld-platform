require 'spec_helper'

describe "beta_access_requests/edit" do
  before(:each) do
    @beta_access_request = assign(:beta_access_request, stub_model(BetaAccessRequest,
      :email => "MyString"
    ))
  end

  it "renders the edit beta_access_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => beta_access_requests_path(@beta_access_request), :method => "post" do
      assert_select "input#beta_access_request_email", :name => "beta_access_request[email]"
    end
  end
end
