Given /^I choose to upload a "([^"]*)" file with "([^"]*)"$/ do |type, filename|
    page.attach_file(type.downcase + "_file", Rails.root + "upload_files" + filename)
end