Given /^there is a user with e-mail address "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  @user = User.find_or_create_by_email(:email => email, :password => password, :password_confirmation => password)
  # Try to make sure the user actually has been saved at some point
  @user.id.should_not == nil
end


Given /^I log in with e-mail address "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  visit login_path
  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Login"
end

Given /^the user group "([^\"]*)" exists$/ do |group|
  @usergroup = Usergroup.create(:name => group)
end

Given /^the user group "([^\"]*)" has admin permissions$/ do |group|
  @usergroup.is_admin = true
  @usergroup.save
end


Given /^the user is member of the group "([^\"]*)"$/ do |group|
  @user.usergroups << Usergroup.find_by_name(group)
  @user.save
end