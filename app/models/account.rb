class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :acc_number, :presence => true
  validates :balance, :presence => true
  validates :user_id, :presence => true
end