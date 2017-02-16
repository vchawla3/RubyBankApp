class Account < ApplicationRecord
  belongs_to :user

  validates :acc_number, :presence => true
  validates :balance, :presence => true
end