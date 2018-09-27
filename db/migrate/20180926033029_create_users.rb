class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.integer :age
      t.string :caste
      t.string :gender
      t.string :city
      t.string :religion
      t.string :phone
      t.string :qualification
      t.integer :qrank
      t.string :current_job
      t.boolean :status

      t.timestamps
    end
  end
end
