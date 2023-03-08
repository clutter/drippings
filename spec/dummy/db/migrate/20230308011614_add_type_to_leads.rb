class AddTypeToLeads < ActiveRecord::Migration[7.0]
  def change
    add_column :leads, :type, :string
  end
end
