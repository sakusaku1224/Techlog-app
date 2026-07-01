require 'rails_helper'

RSpec.describe 'Home', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'トップページの検証' do
    it 'Home#index文字列が表示される' do
      visit '/'
      # 期待する結果 pageでhtmlを取得
      expect(page).to have_content('Home#index')
    end
  end
end
