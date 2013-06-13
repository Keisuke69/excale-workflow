class Application < ActiveRecord::Base
  attr_accessible :body, :end, :start, :to, :user_id, :status, :apply_date
  belongs_to :user
end
