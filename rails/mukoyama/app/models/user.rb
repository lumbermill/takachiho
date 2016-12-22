class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  has_many :settings

  def admin?
    id == 1
  end

  def mine?(setting)
    return false if setting.nil?
    setting = setting.to_i if setting.is_a? String
    setting = Setting.find(setting) if setting.is_a? Fixnum
    return id == setting.user_id
  end
end
