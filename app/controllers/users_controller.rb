class UsersController < ApplicationController

    def show
        user = User.find(params[:id])
        @name = current_user.name
        @posts = user.posts.page(params[:page]).per(5).order("created_at DESC")
        @twitter = current_user.twitter
        @facebook = current_user.facebook
    end
end
