require 'rails_helper'

describe 'User', type: :system do
  before { driven_by :rack_test }
 
  # ユーザー情報入力用の変数
  let(:email) { 'test@example.com' }
  let(:nickname) { '山田花子' }
  let(:password) { 'password' }
  let(:password_confirmation) { password }
 
  describe 'ユーザー登録機能の検証' do
    before { visit '/users/sign_up' }
 
    # ユーザー登録を行う一連の操作を subject にまとめる
    # 事前に準備した値をフォームに代入する
    subject do
      fill_in 'user_nickname', with: nickname
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password_confirmation
      click_button 'ユーザー登録'
    end
 
    context '正常系' do
      it 'ユーザーを作成できる' do
        # よく使う
        expect { subject }.to change(User, :count).by(1) # Userが1つ増える
        expect(page).to have_content('ユーザー登録に成功しました。')
        expect(current_path).to eq('/') # ユーザー登録後はトップページにリダイレクト
      end
    end
 
    context '異常系' do
      context 'エラー理由が1件の場合' do
        let(:nickname) { '' }
        it 'ユーザー作成に失敗した旨のエラーメッセージを表示する' do
          subject
          expect(page).to have_content('エラーが発生したためユーザーは保存されませんでした。')
        end
      end
 
      context 'エラー理由が2件以上の場合' do
        let(:nickname) { '' }
        let(:email) { '' }
        it '問題件数とともに、ユーザー作成に失敗した旨のエラーメッセージを表示する' do
          subject
          expect(page).to have_content('エラーが発生したためユーザーは保存されませんでした。')
        end
      end

      context 'nicknameが空の場合' do
        let(:nickname) { '' }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count) # Userが増えない
          expect(page).to have_content('ニックネーム が入力されていません。') # エラーメッセージのチェック
        end
      end
 
      context 'nicknameが20文字を超える場合' do
        let(:nickname) { 'あ' * 21 }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content('ニックネーム は20文字以下に設定して下さい。')
        end
      end
 
      context 'emailが空の場合' do
        let(:email) { '' }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content('メールアドレス が入力されていません。')
        end
      end
 
      context 'passwordが空の場合' do
        let(:password) { '' }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content('パスワード が入力されていません。')
        end
      end
 
      context 'passwordが6文字未満の場合' do
        let(:password) { 'a' * 5 }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content('パスワード は6文字以上に設定して下さい。')
        end
      end
 
      context 'passwordが128文字を超える場合' do
        let(:password) { 'a' * 129 }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content('パスワード は128文字以下に設定して下さい。')
        end
      end
 
      context 'passwordとpassword_confirmationが一致しない場合' do
        let(:password_confirmation) { "#{password}hoge" } # passwordに"hoge"を足した文字列にする
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content('確認用パスワード が一致していません。')
        end
      end
    end
  end

  describe 'ログイン機能の検証' do
    # 事前にユーザー作成
    before do
      create(:user, nickname: nickname, email: email, password: password, password_confirmation: password) # 事前にユーザー作成
 
      visit '/users/sign_in'
      fill_in 'user_email', with: email
      fill_in 'user_password', with: 'password'
      click_button 'ログイン'
    end
 
    context '正常系' do
      it 'ログインに成功し、トップページにリダイレクトする' do
        expect(current_path).to eq('/')
      end

      it '成功時にフラッシュメッセージが表示される' do
        expect(page).to have_content('ログインしました。')
      end
    end
 
    context '異常系' do
      let(:password) { 'NGpassword' }
      it 'ログインに失敗し、ページ遷移しない' do
        expect(current_path).to eq('/users/sign_in')
      end

      it '失敗時にフラッシュメッセージが表示される' do
        expect(page).to have_content('メールアドレスまたはパスワードが違います。')
      end
    end
  end

  describe 'ログアウト機能の検証' do
    before do
      user = create(:user, nickname: nickname, email: email, password: password,
      password_confirmation: password)
      sign_in user
      visit '/'
      click_button 'ログアウト'

      it 'トップページにリダイレクトする' do
        expect(current_path).to eq('/')
      end

      it 'ログアウト時にフラッシュメッセージが表示される' do
        expect(page).to have_content('ログアウトしました。')
      end
    end
  end
end
