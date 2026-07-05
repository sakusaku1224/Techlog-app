class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # リレーションのおかげで、@userが使用できる
    @posts = @user.posts.order(created_at: :desc)
    @post_count = @posts.count
  end
end
