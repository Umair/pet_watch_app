class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :breed
      t.integer :age
      t.boolean :vaccination_expired
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :pets, :user_id
  end
end
