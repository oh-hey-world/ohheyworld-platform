require 'spec_helper'

describe "user_contacts/show" do
  before(:each) do
    @user_contact = assign(:user_contact, stub_model(UserContact,
      :user_id => 1,
      :contact_id => 2,
      :subject => "Subject",
      :message => "MyText",
      :email => "Email",
      :phone => "Phone"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Subject/)
    rendered.should match(/MyText/)
    rendered.should match(/Email/)
    rendered.should match(/Phone/)
  end
end
