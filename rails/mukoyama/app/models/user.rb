class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  has_many :devices

  def admin?
    id == 1
  end

  def mine?(device)
    return false if device.nil?
    device = device.to_i if device.is_a? String
    device = Device.find(device) if device.is_a? Fixnum
    return id == device.user_id
  end
end
