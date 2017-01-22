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
end
