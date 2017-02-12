class Account < ApplicationRecord
  belongs_to :person

  validates :acc_number, :presence => true
  validates :balance, :presence => true

end
