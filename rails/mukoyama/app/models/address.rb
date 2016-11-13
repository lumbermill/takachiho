class Address < ActiveRecord::Base
  belongs_to :settings, foreign_key: :raspi_id
  has_many :mail_logs

  def phone?
    mail.match /^\+[0-9]+$/
  end

  def mail?
    mail.match /^.+@.+$/
  end

  def type
    if phone?
      "電話"
    elsif mail?
      "メール"
    else
      "LINE"
    end
  end
end
