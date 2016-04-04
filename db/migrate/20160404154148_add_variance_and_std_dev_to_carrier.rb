class AddVarianceAndStdDevToCarrier < ActiveRecord::Migration
  def change
    add_column :carriers, :early_arr_num, :integer
    add_column :carriers, :late_arr_num, :integer
    add_column :carriers, :late_dep_num, :integer
    add_column :carriers, :arrival_delay_variance, :float
    add_column :carriers, :departure_delay_variance, :float
  end
end
