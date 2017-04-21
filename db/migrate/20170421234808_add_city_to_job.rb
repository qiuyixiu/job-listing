class AddCityToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :city, :string
  end
end
