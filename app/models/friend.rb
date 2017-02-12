class Friend < ApplicationRecord
  belongs_to :person

  validates :friend1, :presence => true
  validates :friend2, :presence => true
end
