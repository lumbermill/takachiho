class PagesController < ApplicationController
  def root
    render layout: 'root'
  end

  def dashboard
    @raspi_list = Setting.where(user_id: current_user.id)
  end
end
