class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :acc_number, :presence => true, :length => {minimum: 9, maximum: 9}, :uniqueness => true
  validates :user_id, :presence => true
  validates :balance, numericality: { :greater_than_or_equal_to => 0 }
end