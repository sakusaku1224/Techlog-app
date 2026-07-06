require 'rails_helper'

# modelのテストを明示しなくとも良い User, type: :model
describe User do
  # シンボル形式　テストでの型
  let(:nickname) { '山田花子' }
  let(:email) { 'test@example.com' }
  let(:password) { '12345678' }
  let(:user) { User.new(nickname: nickname, email: email, password: password, password_confirmation: password) }
  describe '.first' do
    # テストが実行される前の処理
    before do
      @user = create(:user, nickname: nickname, email: email)
      @post = create(:post, title: 'タイトル', content: '本文', user_id: @user.id)
    end

    # described_classは Userクラスを指す
    # subject変数に入れる User.first
    subject { described_class.first }

    it '事前に作成した通りのUserを返す' do
      expect(subject.nickname).to eq('山田花子')
      expect(subject.email).to eq('test@example.com')
    end

    it '紐づくPostの情報を取得できる' do
      expect(subject.posts.size).to eq(1)
      expect(subject.posts.first.title).to eq('タイトル')
      expect(subject.posts.first.content).to eq('本文')
      expect(subject.posts.first.user_id).to eq(@user.id)
    end
  end

  describe 'validation' do
    describe 'nickname属性' do
      describe '文字数制限の検証' do
        context 'nicknameが20文字以下の場合' do
          # コンテキストの中でオブジェクトを上書き
          let(:nickname) { 'あいうえおかきくけこさしすせそたちつてと' } # 20文字
          it 'Userオブジェクトは有効' do
            expect(user.valid?).to be(true)
          end
        end
        context 'nicknameが20文字を超える場合' do
          let(:nickname) { 'あいうえおかきくけこさしすせそたちつてとな' } # 21文字

          it 'User オブジェクトは無効である' do
            expect(user.valid?).to be(false)
            # userオブジェクトのerrorsにはエラー情報が格納されている
            expect(user.errors[:nickname]).to include('は20文字以下に設定して下さい。')
          end
        end
      end

      describe '存在の検証' do
        context 'nicknameが空欄の場合' do
          let(:nickname) { '' }

          it 'Userオブジェクトは無効' do
            expect(user.valid?).to be(false)
            expect(user.errors[:nickname]).to include('が入力されていません。')
          end
        end
      end
    end
  end
end
