class Transaction < ApplicationRecord
  belongs_to :account

  validates :type, :presence => true
  validates :status, :presence => true
  validates :amount, :presence => true
  validates :start_date, :presence => true

end
