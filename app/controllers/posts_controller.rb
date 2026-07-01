class PostsController < ApplicationController
  # ログインしているか判断
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_post, only: [:show, :destroy]

  def index
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    # ログインユーザのIDを紐付ける(定型)
    @post.user_id = current_user.id
    if @post.save
      redirect_to root_path, notice: '投稿しました'
    else
      flash.now[:alert] = '投稿に失敗しました'
      render :new
    end
  end

  def show
    # ID取得済み
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private
  # ストロングパラメータ
  def post_params
    params.require(:post).permit(:title, :content)
  end
  # ID取得
  def set_post
    @post = current_user.posts.find(params[:post_id])
  end
end
