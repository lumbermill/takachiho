class Device < ActiveRecord::Base
  belongs_to :user
  has_many :addresses, foreign_key: :device_id
  has_many :temps
  has_many :pictures

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

  # Returns 0-0000 token for LINE bot if the setting is readable.
  def id4line
    return "#{id}" unless readable?
    t = token4read[0,4]
    return "#{id}-#{t}"
  end

  def picture_groups(offset=0,max_length=24)
    PictureGroup.where(device_id: id).order("head desc").limit(max_length).offset(offset)
  end

  def picture_group_paths(offset=0,max_length=24)
    pgs = picture_groups(offset,max_length)
    paths = pgs.map { |v| "/pictures/#{id}/#{v.head}.jpg" }
    return paths
  end

  def latest_pictures(limit=3)
    Picture.where(device_id: id).order("dt desc").limit(limit)
  end
end
