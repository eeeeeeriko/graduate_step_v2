class CreateWineRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :wine_records do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :acidity
      t.integer :tannin
      t.integer :sweetness
      t.integer :satisfaction

      t.timestamps
    end
  end
end
