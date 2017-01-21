class PagesController < ApplicationController
  def root
  end

  def howto
  end

  def dashboard
    @items = Item.where(user: current_user).order(:code).limit(100)
  end
end
