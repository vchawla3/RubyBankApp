class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :friends
  has_many :accounts
  has_many :account_requests


  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #validates :name, :presence => true
  #validates :email, :presence => true, :uniqueness => true, :length => { maximum: 255 },
  #          format: { with: VALID_EMAIL_REGEX }
  #validates :password, :presence => true, :confirmation => true #password_confirmation attr
  #validates_length_of :password, :in => 6..20, :on => :create

end
