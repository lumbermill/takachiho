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

  def baseurl
    url = request.protocol + request.host
    if request.port != 80 || request.port != 443
      url += ":" + request.port.to_s
    end
    return url
  end

  def line_add_frinend_button
    # Generated on https://media.line.me/en/how_to_install.html#addfriend
    html =<<-EOT
    <div class="line-it-button" data-lang="en" data-type="friend" data-lineid="@lut9562u" style="display: none;"></div>
    <script src="https://d.line-scdn.net/r/web/social-plugin/js/thirdparty/loader.min.js" async="async" defer="defer"></script>
    EOT
    html.html_safe
  end

  def city_list
    sql = "select id,name,name_jp from weathers_cities"
    results = ActiveRecord::Base.connection.select_all(sql)
    return {} if results.length == 0
    return results
  end

  def send_message(addresses, msg, force=false)
    now = DateTime.now
    addresses.each do |address|
      next if (!force && address.active != true)
      ts = Notification.where(address_id: address.id, delivered: true).maximum(:created_at)
      print "  #{address.address}"
      deliver = force || ts.nil? || ts + address.snooze.minute < now
      if deliver
        case address.type
        when "電話"
          puts " call"
          Mailer.make_call(address.address, msg).deliver_now
        when "メール",""
          puts " mail"
          Mailer.send_mail(address.address, "Notificaton from Mukoyama", msg).deliver_now
        when "Slack"
          puts " slack"
          Mailer.send_slack(address.address,msg).deliver_now
        when "LINE"
          puts " line"
          Mailer.send_line(address.address, msg).deliver_now
        end
      else
        puts " snoozed"
      end
      Notification.create(address_id: address.id, delivered: deliver)
    end
  end
end
