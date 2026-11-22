class WineRecord < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :acidity, :tannin, inclusion: { in: 1..3 }
  validates :sweetness, inclusion: { in: 1..2 }
  validates :satisfaction, inclusion: { in: 1..3 }
end