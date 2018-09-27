class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.integer :to_id
      t.integer :from_id

      t.timestamps
    end
  end
end
