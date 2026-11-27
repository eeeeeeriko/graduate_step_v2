
require 'rails_helper'

RSpec.describe WineRecord, type: :model do
  let(:user) do
    User.create!(
      name: 'テストユーザー',
      email: 'test@example.com',
      password: 'password'
    )
  end

  let(:wine_record) do
    WineRecord.new(
      user: user,
      name: 'テストワイン',
      acidity: 2,
      tannin: 2,
      sweetness: 1,
      satisfaction: 3
    )
  end

  describe 'バリデーション' do
    it '正しい値であれば保存できる' do
      expect(wine_record).to be_valid
    end

    it 'ワイン名が空欄の場合は無効になる' do
      wine_record.name = ''
      expect(wine_record).not_to be_valid
    end

    {
      acidity: 1..3,
      tannin: 1..3,
      sweetness: 1..2,
      satisfaction: 1..3
    }.each do |attribute, range|
      it "#{attribute}が範囲内の場合は有効になる" do
        wine_record.public_send("#{attribute}=", range.first)
        expect(wine_record).to be_valid

        wine_record.public_send("#{attribute}=", range.last)
        expect(wine_record).to be_valid
      end

      it "#{attribute}が範囲外の場合は無効になる" do
        wine_record.public_send("#{attribute}=", range.first - 1)
        expect(wine_record).not_to be_valid

        wine_record.public_send("#{attribute}=", range.last + 1)
        expect(wine_record).not_to be_valid
      end
    end
  end

  describe '関連付け' do
    it 'ユーザーに紐づくワイン記録を取得できる' do
      wine_record.save!
      expect(user.wine_records).to include(wine_record)
    end

    it 'ユーザーが設定されていない場合は無効になる' do
      wine_record.user = nil
      expect(wine_record).not_to be_valid
    end
  end
end
