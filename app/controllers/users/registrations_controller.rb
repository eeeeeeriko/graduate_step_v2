class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # 会員情報変更成功後の遷移先を設定する
  def after_update_path_for(resource)
    wine_records_path
  end
end