class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tokens
  
  #validaciones
  #los valida automaticamente por el lado de devise
  #validates :email, uniqueness: true, presence: true
  #validates :password, presence: true

  def self.from_login(data)
    u = User.where("email = ?", data[:email]).first
  end

end
