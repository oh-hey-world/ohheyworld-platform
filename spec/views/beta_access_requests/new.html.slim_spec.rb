require 'spec_helper'

describe "beta_access_requests/new" do
  before(:each) do
    assign(:beta_access_request, stub_model(BetaAccessRequest,
      :email => "MyString"
    ).as_new_record)
  end

  it "renders new beta_access_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => beta_access_requests_path, :method => "post" do
      assert_select "input#beta_access_request_email", :name => "beta_access_request[email]"
    end
  end
end
