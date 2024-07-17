class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)
    current_user.save ? flash[:notice] = "Following friend." : flash[:alert] = "There was something wrong with the tracking request."
    if current_user.save
      @friends = current_user.friends
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("friends-table", partial: "friends/list", locals: { friends: @friends })
        end
      end
    end
    # redirect_to my_friends_path
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    flash[:notice] = "Stopped following."
    redirect_to my_friends_path
  end
end
