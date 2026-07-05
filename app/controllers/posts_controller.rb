class PostsController < ApplicationController
  # ログインしているか判断
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    # 作成順に並べる
    @posts = Post.limit(10).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    # ログインユーザのIDを紐付ける(定型)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path, notice: '投稿しました'
    else
      flash.now[:alert] = '投稿に失敗しました'
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    redirect_to posts_path, notice: '投稿が削除されました'
  end

  private
  # ストロングパラメータ
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
