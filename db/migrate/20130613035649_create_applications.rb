class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :user_id
      t.datetime :start
      t.datetime :end
      t.string :to
      t.text :body

      t.timestamps
    end
  end
end
