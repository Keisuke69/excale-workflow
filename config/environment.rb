# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Workflow::Application.initialize!
require File.join(Rails.root.to_s, "lib", "tasks", "initializer")
