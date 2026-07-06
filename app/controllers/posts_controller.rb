class PostsController < ApplicationController
  # ログインしているか判断
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:edit, :update, :destroy]
  def index
    # 作成順に並べる
    @posts = Post.limit(10).order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    # 取得済み
  end

  def create
    @post = Post.new(post_params)
    # ログインユーザのIDを紐付ける(定型)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path, notice: '投稿しました'
    else
      flash.now[:alert] = '投稿に失敗しました'
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @own_post.update(post_params)
      redirect_to posts_path, notice: '投稿を更新しました'
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @own_post.destroy
    redirect_to posts_path, notice: '投稿が削除されました'
  end

  private

  # ストロングパラメータ
  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_post
    @own_post = current_user.posts.find(params[:id])
  end
end
