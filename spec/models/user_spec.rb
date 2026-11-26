
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    let(:user) do
      User.new(
        name: 'テストユーザー',
        email: 'new_user@example.com',
        password: 'password123'
      )
    end

    it '名前・メールアドレス・パスワードが正しければ有効である' do
      expect(user).to be_valid
    end

    it '名前が空欄の場合は無効である' do
      user.name = ''
      expect(user).not_to be_valid
    end

    it 'メールアドレスが空欄の場合は無効である' do
      user.email = ''
      expect(user).not_to be_valid
    end

    it 'メールアドレスに@がない場合は無効である' do
      user.email = 'invalid-email'
      expect(user).not_to be_valid
    end

    it 'メールアドレスに空白が含まれる場合は無効である' do
      user.email = 'invalid email@example.com'
      expect(user).not_to be_valid
    end

    it '登録済みのメールアドレスは使用できない' do
      user.email = User.find_by!(email: 'user1@example.com').email
      expect(user).not_to be_valid
    end

    it 'メールアドレスの大文字小文字だけが異なる場合も重複として扱う' do
      user.email = User.find_by!(email: 'user1@example.com').email.upcase
      expect(user).not_to be_valid
    end

    it 'パスワードが空欄の場合は無効である' do
      user.password = ''
      expect(user).not_to be_valid
    end

    it 'パスワードが5文字の場合は無効である' do
      user.password = 'abcde'
      expect(user).not_to be_valid
    end

    it 'パスワードが6文字の場合は有効である' do
      user.password = 'abcdef'
      expect(user).to be_valid
    end
  end
end
