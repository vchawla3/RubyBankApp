class Friend < ApplicationRecord
  belongs_to :user

  validates :friend1, :presence => true
  validates :friend2, :presence => true
end
