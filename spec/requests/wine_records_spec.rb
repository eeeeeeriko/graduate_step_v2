require 'rails_helper'

RSpec.describe 'WineRecords', type: :request do
  let(:user) do
   User.create!(
    name: 'テストユーザー',
    email: 'request_user@example.com',
    password: 'password123'
    )
  end

  before do
    sign_in user
  end
  #新規登録（Create）
  describe 'POST /wine_records' do
    context '正常系' do
      it '正しい入力でワインを登録できる' do
        expect {
          post wine_records_path, params: {
            wine_record: {
              name: '新しいワイン',
              acidity: 2,
              tannin: 2,
              sweetness: 1,
              satisfaction: 3
            }
          }
        }.to change(WineRecord, :count).by(1)

        expect(response).to redirect_to(wine_records_path)
        expect(WineRecord.last.user).to eq(user)
      end
    end

    context '異常系' do
      it 'ワイン名が空欄の場合は登録できない' do
        expect {
          post wine_records_path, params: {
            wine_record: {
              name: '',
              acidity: 2,
              tannin: 2,
              sweetness: 1,
              satisfaction: 3
            }
          }
        }.not_to change(WineRecord, :count)

       expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
  #一覧表示（Read）
  describe 'GET /wine_records' do
   let!(:my_wine) do
    user.wine_records.create!(
      name: '自分のワイン',
      acidity: 2,
      tannin: 2,
      sweetness: 1,
      satisfaction: 3
    )
  end

  let!(:other_wine) do
    other_user = User.create!(
      name: '別ユーザー',
      email: 'other_request_user@example.com',
      password: 'password123'
    )

    other_user.wine_records.create!(
      name: '他人のワイン',
      acidity: 1,
      tannin: 3,
      sweetness: 2,
      satisfaction: 2
    )
  end

    it '自分のワインが一覧に表示される' do
    get wine_records_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(my_wine.name)
  end

    it '他ユーザーのワインは一覧に表示されない' do
    get wine_records_path

    expect(response.body).not_to include(other_wine.name)
  end
end
  #編集（edit）
  describe 'GET /wine_records/:id/edit' do
    let!(:wine) do
      user.wine_records.create!(
        name: '編集前のワイン',
        acidity: 2,
        tannin: 2,
        sweetness: 1,
        satisfaction: 3
      )
    end

    it '自分のワインの編集画面を表示できる' do
      get edit_wine_record_path(wine)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /wine_records/:id' do
    let!(:wine) do
      user.wine_records.create!(
        name: '更新前のワイン',
        acidity: 2,
        tannin: 2,
        sweetness: 1,
        satisfaction: 3
      )
    end

    it '自分のワインを更新できる' do
      patch wine_record_path(wine), params: {
        wine_record: {
          name: '更新後のワイン'
        }
      }

      expect(response).to redirect_to(wine_records_path)
      expect(wine.reload.name).to eq('更新後のワイン')
    end
  end
  # 削除（Delete）
  describe 'DELETE /wine_records/:id' do
    let!(:wine) do
      user.wine_records.create!(
        name: '削除するワイン',
        acidity: 2,
        tannin: 2,
        sweetness: 1,
        satisfaction: 3
      )
    end

    it '自分のワインを削除できる' do
      expect {
        delete wine_record_path(wine)
      }.to change(WineRecord, :count).by(-1)

      expect(response).to redirect_to(wine_records_path)
    end
  end

  # 他ユーザーのワインへのアクセス制限
  describe '他ユーザーのワインへのアクセス制限' do
    let!(:other_wine) do
      other_user = User.create!(
        name: '別ユーザー',
        email: 'other_access_user@example.com',
        password: 'password123'
      )

      other_user.wine_records.create!(
        name: '他ユーザーのワイン',
        acidity: 2,
        tannin: 2,
        sweetness: 1,
        satisfaction: 3
      )
    end

    it '他ユーザーのワインの編集画面にアクセスできない' do
      get edit_wine_record_path(other_wine)

      expect(response).to have_http_status(:not_found)
    end
    it '他ユーザーのワインを更新できない' do
      patch wine_record_path(other_wine), params: {
        wine_record: { name: '不正に変更したワイン' }
      }

      expect(response).to have_http_status(:not_found)
      expect(other_wine.reload.name).to eq('他ユーザーのワイン')
    end

    it '他ユーザーのワインを削除できない' do
      expect {
        delete wine_record_path(other_wine)
      }.not_to change(WineRecord, :count)

      expect(response).to have_http_status(:not_found)
      expect(WineRecord.exists?(other_wine.id)).to be true
    end
  end

end
