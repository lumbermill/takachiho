class Address < ActiveRecord::Base
  belongs_to :settings, foreign_key: :raspi_id
  has_many :mail_logs

  def phone?
    mail.match /\+[0-9]+/
  end
end
