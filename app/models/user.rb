class User < ActiveRecord::Base
  attr_accessible :password, :removed, :role, :user
  has_many :applications
end
