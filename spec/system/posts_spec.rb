require 'rails_helper'
 
describe 'Post', type: :system do
  before do
    driven_by :rack_test
    @user = create(:user)
    @post = create(:post, title: 'RSpec学習完了', content: 'System Specを作成した', user_id: @user.id )
  end
 
  # 投稿フォーム
  let(:title) { 'テストタイトル' }
  let(:content) { 'テスト本文' }
 
  describe 'ログ投稿機能の検証' do
    # ログ投稿を行う一連の操作を subject にまとめる
    subject do
      fill_in 'post_title', with: title
      fill_in 'post_content', with: content
      click_button 'ログを記録'
    end
 
    context 'ログインしていない場合' do
      before { visit '/posts/new' }
      it 'ログインページへリダイレクトする' do
        expect(current_path).to eq('/users/sign_in')
        expect(page).to have_content('ログインしてください。')
      end
    end
 
    context 'ログインしている場合' do
      before do
        sign_in @user
        visit '/posts/new'
      end
      it 'ログインページへリダイレクトしない' do
        expect(current_path).not_to eq('/users/sign_in')
      end
 
      context 'パラメータが正常な場合' do
        it 'Postを作成できる' do
          expect { subject }.to change(Post, :count).by(1)
          expect(current_path).to eq('/posts')
          expect(page).to have_content('投稿しました')
        end
      end
 
      context 'パラメータが異常な場合' do
        let(:title) { nil }
        it 'Postを作成できない' do
          expect { subject }.not_to change(Post, :count)
          expect(page).to have_content('投稿に失敗しました')
        end
 
        it '入力していた内容は維持される' do
          subject
          expect(page).to have_field('post_content', with: content)
        end
      end
    end
  end

  describe 'ログ詳細機能の検証' do
    before { visit "posts/#{@post.id}" }

    it 'Postの詳細が表示される' do
      expect(page).to have_content('RSpec学習完了')
      expect(page).to have_content('System Specを作成した')  
      expect(page).to have_content(@user.nickname)  
    end
  end

  describe 'ログ一覧の検証' do
    before do
      @post2 = create(:post, title: 'RSpec学習完了2', content: 'System Specを作成した2', user_id: @user.id)
      visit '/posts'
    end

    it '1件目のPostの詳細が表示される' do
      expect(page).to have_content('RSpec学習完了')
      expect(page).to have_content('System Specを作成した')
      expect(page).to have_content(@user.nickname)
    end
  
    it '2件目のPostの詳細が表示される' do
      expect(page).to have_content('RSpec学習完了2')
      expect(page).to have_content('System Specを作成した2')
      expect(page).to have_content(@user.nickname)
    end

    it '投稿タイトルをクリックすると詳細ページに遷移する' do
      click_link 'RSpec学習完了'
      expect(current_path).to eq("/posts/#{@post.id}")
    end

  end

  describe 'ログ削除機能の検証' do
    context '投稿したユーザーでログインしている場合' do
      before do
        sign_in @user # テストユーザーでログイン
        visit "/posts/#{@post.id}" # 投稿詳細ページにアクセス
      end
  
      it '削除ボタンを表示する' do
        expect(page).to have_button('削除') # 削除ボタンが表示されていることを確認
      end
  
      it '削除ボタンをクリックすると削除できる' do
        expect do
          click_button '削除'
        end.to change(Post, :count).by(-1) # 削除ボタンをクリックすると投稿が1件減ることを確認
  
        expect(current_path).to eq('/posts') # 投稿一覧ページにリダイレクトされていることを確認
        expect(page).to have_content('投稿が削除されました') # 削除完了メッセージが表示されていることを確認
        expect(page).not_to have_content('RSpec学習完了') # 削除した投稿が一覧に表示されていないことを確認
      end
    end
  
    context 'ログインしていない場合' do
      it '削除ボタンを表示しない' do
        visit "/posts/#{@post.id}" # 投稿詳細ページにアクセス
        expect(page).not_to have_button('削除') # 削除ボタンが表示されていないことを確認
      end
  
      it '直接リクエストを投げても削除されない' do
        expect do
          delete post_path(@post) # DELETE リクエストを直接送信
        end.not_to change(Post, :count) # 投稿レコードの数が変わらないことを確認
      end
    end

    # 自作テスト
    context '別のユーザーでログインしている時' do
      before do
        @user2 = create(:user, nickname: 'Yamada')
        @own_post = create(:post, title: '自作テストを追加', content: 'テスト通過', user_id: @user2.id)
        sign_in @user2
        visit '/posts' # テストユーザーでログイン
      end
      it '他のユーザーの投稿に削除ボタンを表示しない' do
        visit "/posts/#{@post.id}" # 投稿詳細ページにアクセス
        expect(page).not_to have_button('削除') # 削除ボタンが表示されていないことを確認
      end
  
      it '他のユーザーの投稿に直接リクエストを投げても削除されない' do
        expect do
          delete post_path(@post) # DELETE リクエストを直接送信
        end.not_to change(Post, :count) # 投稿レコードの数が変わらないことを確認
      end

      it '自分のユーザーidと一致する投稿では削除ボタンが表示される' do
        visit "/posts/#{@own_post.id}"
        expect(page).to have_button('削除')
      end
    end
  end
end
