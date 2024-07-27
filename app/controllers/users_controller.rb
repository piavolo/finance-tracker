class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def search
    @search_performed = true
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends) if @friends
      unless @friends.empty?
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("result", partial: "users/friend_result", locals: { friends: @friends }) }
          format.html { render 'users/my_friends' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "User not found."
          format.turbo_stream { render turbo_stream: turbo_stream.replace("result", partial: "users/friend_result", locals: { friends: nil }) }
          format.html { render 'users/my_friends', alert: flash.now[:alert] }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a friend name or email to search."
        format.turbo_stream { render turbo_stream: turbo_stream.replace("result", partial: "users/friend_result", locals: { friends: nil }) }
        format.html { render 'users/my_friends', alert: flash.now[:alert] }
      end
    end
  end
end
