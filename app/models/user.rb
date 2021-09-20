class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false}
  validates :password, presence: true, length: { in: 3..16 }

  def self.authenticate_with_credentials(email, password)
    user = User.find_by_email(email.downcase.delete(' '))

    if user && user.authenticate(password)
      return user
    end 

    return nil
  end
end
