class UsersController < ApplicationController
  def index
    raise 'Only admin can access this page.' unless current_user.admin?
    @users = User.all.order(:id)
  end

  def login_as
    raise 'Only admin can access this page.' unless current_user.admin?
    id = params[:id]
    sign_in(User.find(id))
    redirect_to dashboard_path, notice: "ID: #{id}"
  end
end
