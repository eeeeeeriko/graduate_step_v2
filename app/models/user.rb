class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable

  # 名前が空欄の場合は保存できないようにする
  validates :name, presence: true

  # 1人のユーザーが複数のワイン記録を持つ
  has_many :wine_records, dependent: :destroy
end