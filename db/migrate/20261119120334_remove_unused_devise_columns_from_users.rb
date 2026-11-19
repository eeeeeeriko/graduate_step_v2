class RemoveUnusedDeviseColumnsFromUsers < ActiveRecord::Migration[7.2]
  def change
    # パスワード再設定用トークンを削除する
    remove_column :users, :reset_password_token, :string

    # パスワード再設定メールの送信日時を削除する
    remove_column :users, :reset_password_sent_at, :datetime

    # ログイン状態の記憶に関する日時を削除する
    remove_column :users, :remember_created_at, :datetime
  end
end
