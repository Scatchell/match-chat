class UsersController < ApplicationController
  before_action :find_user

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def find_user
    @user = User.find(params[:id])
  end
end
