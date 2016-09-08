class UsersController < ApplicationController
  def index
    raise 'Only admin can access this page.' unless current_user.admin?
    @users = User.all.order(:id)
  end
end
