class Token < ApplicationRecord
  belongs_to :user
  before_create :generate_token
  validates :user_id, presence:true
  def is_valid?
    DateTime.now < self.expires_at
  end
  private
  def generate_token
    begin
      #generacion del token
      self.token = SecureRandom.hex(20)
      #el while se mantiene hasta que no exista un token igual para dejarlo unico
    end while Token.where(token: self.token).any?
    #genera una fecha de expiracion de 1 mes desde fecha actual
    self.expires_at ||= 1.month.from_now
  end

end
