class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale

  $access_log = {}

  # 全リンクにlocale情報をセットする
  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  # リンクの多言語化に対応する
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def set_access_log
    page = "#{controller_name}-#{action_name}"
    logger.debug("セットするよ！！")
    logger.debug(page)
    logger.debug(request.session_options[:id])
    $access_log[request.session_options[:id]] = {page: page, timestamp: Time.now}
  end

  def get_access_log
    page = "#{controller_name}-#{action_name}"
    count = 0
    logger.debug("ゲットだよ！！")
    logger.debug($access_log)
    $access_log.each do |hash, log|
      if log[:timestamp] < Time.now - 60 * 10
        # 10分以上更新のないレコードは削除する
        $access_log.delete(hash)
        next
      end
      next unless log[:page] == page
      count += 1
    end
    return count
  end
end
