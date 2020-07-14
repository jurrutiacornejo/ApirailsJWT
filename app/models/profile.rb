class Profile < ApplicationRecord
  belongs_to :user
  validates  :name, presence:true
  validates  :last_name, presence:true
  validates  :age, presence:true
end
