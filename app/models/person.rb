class Person < ApplicationRecord
  has_many :friends
  has_many :accounts

  #has_secure_password
  #salt = BCrypt::Engine.generate_salt
  #self.password= BCrypt::Engine.hash_secret(password, salt)

  #before_save :encrypt_password
  #after_save :clear_password
  #def encrypt_password
  #  if password.present?
  #    self.salt = BCrypt::Engine.generate_salt
  #    self.self.password= BCrypt::Engine.hash_secret(password, salt)
  #  end
  #end
  #def clear_password
  #  self.password = nil
  #end

  #attr_accessor :password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :LName, :presence => true
  validates :FName, :presence => true
  validates :email, :presence => true, :uniqueness => true, :length => { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }
  #validates :password, :presence => true, :confirmation => true #password_confirmation attr
  #validates_length_of :password, :in => 6..20, :on => :create

end
