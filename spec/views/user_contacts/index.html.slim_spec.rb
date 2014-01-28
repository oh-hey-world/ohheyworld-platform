require 'spec_helper'

describe "user_contacts/index" do
  before(:each) do
    assign(:user_contacts, [
      stub_model(UserContact,
        :user_id => 1,
        :contact_id => 2,
        :subject => "Subject",
        :message => "MyText",
        :email => "Email",
        :phone => "Phone"
      ),
      stub_model(UserContact,
        :user_id => 1,
        :contact_id => 2,
        :subject => "Subject",
        :message => "MyText",
        :email => "Email",
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of user_contacts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
  end
end
