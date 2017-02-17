class Setting < ActiveRecord::Base
  has_many :addresses, foreign_key: :raspi_id
  belongs_to :user
  has_many :sakura_iot_modules, foreign_key: :raspi_id#, dependent: :destroy
  accepts_nested_attributes_for :sakura_iot_modules, reject_if: :new_record?

  # Returns true if the sensor is visible via the link with token(without authentication).
  def readable?
    token4read != nil && token4read.length > 0
  end

  def city_name
    return nil if city_id.nil?
    sql = "select name,name_jp from weathers_cities where id = #{city_id}"
    results = ActiveRecord::Base.connection.select_all(sql)
    return nil if results.length == 0
    row = results.to_a[0]
    return row["name_jp"] unless row["name_jp"].empty?
    return row["name"]
  end
end
