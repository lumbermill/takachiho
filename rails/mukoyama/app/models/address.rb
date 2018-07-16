class Address < ActiveRecord::Base
  belongs_to :device, foreign_key: :device_id
  has_many :notifications

  def phone?
    address.match /^\+[0-9]+$/
  end

  def mail?
    address.match /^.+@.+$/
  end

  def slack?
    address.match /^https.+slack.com.+/
  end

  # アドレスのタイプ、address_type列は更新されていない…
  def type
    if phone?
      "電話"
    elsif mail?
      "メール"
    elsif slack?
      "Slack"
    else
      "LINE"
    end
  end
end
