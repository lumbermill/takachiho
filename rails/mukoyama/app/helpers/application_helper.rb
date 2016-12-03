module ApplicationHelper
  def format_timestamp(ts)
    return "" if ts.nil?
    tz = ts.strftime("%Z")
    tz = tz == "UTC" ? "" : " "+tz # MySQLからとってくると常にUTCになる？？(不要?)
    if ts.to_date == Date.today && tz.empty?
      return ts.strftime("%H:%M")
    elsif ts.year == Date.today.year && tz.empty?
      return ts.strftime("%m/%d %H:%M")
    end
    return ts.strftime("%Y/%m/%d %H:%M")+tz
  end
end
