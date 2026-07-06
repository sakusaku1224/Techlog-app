require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  before do
    @user = create(:user)
    @post = create(:post, user_id: @user.id)
  end

  describe 'GET /posts/new' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        get '/posts/new'
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされる' do
        get '/posts/new'
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context 'ログインしている場合' do
      before { sign_in @user }
      it 'HTTPステータス200を返す' do
        get '/posts/new'
        expect(response).to have_http_status(200)
      end

      it 'ログインページにリダイレクトされない' do
        get '/posts/new'
        expect(response).not_to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'GET /posts/:id' do
    context 'ログインしていない場合' do
      it 'HTTPステータス200を返す' do
        get "/posts/#{@post.id}"
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしている場合' do
      it 'HTTPステータス200を返す' do
        sign_in @user
        get "/posts/#{@post.id}"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /posts' do
    context 'ログインしていない場合' do
      it 'HTTPステータス200を返す' do
        get "/posts/#{@post.id}"
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしている場合' do
      it 'HTTPステータス200を返す' do
        sign_in @user
        get "/posts/#{@post.id}"
        expect(response).to have_http_status(200)
      end
    end
  end

  # 以下自作テスト
  describe 'GET /posts/:id/edit' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        get "/posts/#{@post.id}/edit"
        expect(response).to have_http_status(302)
      end
      it 'ログインページにリダイレクトされる' do
        get "/posts/#{@post.id}/edit"
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context 'ログインしている場合' do
      it 'HTTPステータス200を返す' do
        sign_in @user
        get "/posts/#{@post.id}/edit"
        expect(response).to have_http_status(200)
      end
    end

    context '他のユーザーでログインしている場合' do
      before { @user2 = create(:user) }
      it 'HTTPステータス404を返す' do
        sign_in @user2
        get "/posts/#{@post.id}/edit"
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'PATCH /posts/:id' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        patch "/posts/#{@post.id}", params: { post: { title: '更新後タイトル', content: '更新後本文' } }
        expect(response).to have_http_status(302)
      end
      it 'ログインページにリダイレクトされる' do
        patch "/posts/#{@post.id}", params: { post: { title: '更新後タイトル', content: '更新後本文' } }
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context 'ログインしている場合' do
      it 'HTTPステータス302を返す' do
        sign_in @user
        patch "/posts/#{@post.id}", params: { post: { title: '更新後タイトル', content: '更新後本文' } }
        expect(response).to have_http_status(302)
      end
    end

    context '他のユーザーでログインしている場合' do
      before { @user2 = create(:user) }
      it 'HTTPステータス404を返す' do
        sign_in @user2
        patch "/posts/#{@post.id}", params: { post: { title: '更新後タイトル', content: '更新後本文' } }
        expect(response).to have_http_status(404)
      end
    end
  end
end
