class Transaction < ApplicationRecord
  belongs_to :account

  validates :transtype, :presence => true
  validates :status, :presence => true
  validates :amount, :presence => true, numericality: { :greater_than_or_equal_to => 0.01 }
  validates :start_date, :presence => true
end
