class Friend < ApplicationRecord
  belongs_to :user

  validates :friend1, :presence => true,  :format => { :without => /\ADatabase/, message: "This friend was not found in the system"}
  validates :friend1, :format => { :without => /\ARepeat/, message: "You cannot be friends with yourself"}
  validates :friend1, :format => { :without => /\ADuplicate/, message: "This friend relationship already exists"}
  validates :friend2, :presence => true, :format => { :without => /\ADatabase/, message: "This friend was not found in the system"}
  validates :friend2, :format => { :without => /\ARepeat/, message: "You cannot be friends with yourself"}
end
