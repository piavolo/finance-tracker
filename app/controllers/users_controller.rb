class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friend = params[:friend]
      if @friend
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("result", partial: "users/friend_result", locals: { friend: @friend }) }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "User not found."
          format.turbo_stream { render turbo_stream: turbo_stream.replace("result", partial: "users/friend_result", locals: { friend: nil }) }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a friend name or email to search."
        format.turbo_stream { render turbo_stream: turbo_stream.replace("result", partial: "users/friend_result", locals: { friend: nil }) }
        format.html { redirect_to my_friends_path, alert: flash.now[:alert] }
      end
    end
  end
end
