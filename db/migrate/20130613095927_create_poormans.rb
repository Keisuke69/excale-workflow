class CreatePoormans < ActiveRecord::Migration
  def change
    create_table :poormans_crons, :force => true do |t|
      t.column :id,           :integer
      t.column :name,         :string
      t.column :interval,     :integer
      t.column :performed_at, :datetime
    end
  end
end





