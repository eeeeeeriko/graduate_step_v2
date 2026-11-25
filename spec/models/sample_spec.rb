require "rails_helper"

RSpec.describe "テストデータの読み込み" do
  fixtures :users, :wine_records

  it "ユーザーとワイン記録が紐づいていること" do
    user = users(:user_one)
    wine = wine_records(:wine_one)

    expect(wine.user).to eq(user)
  end
end