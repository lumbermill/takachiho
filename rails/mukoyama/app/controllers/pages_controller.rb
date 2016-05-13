class PagesController < ApplicationController
  def root
  end

  def about
  end

  def dashboard
    @raspi_list = Setting.where(user_id: current_user.id)
  end
end
