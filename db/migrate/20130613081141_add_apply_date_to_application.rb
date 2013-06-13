class AddApplyDateToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :apply_date, :datetime
  end
end
