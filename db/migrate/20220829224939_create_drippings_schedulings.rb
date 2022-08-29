class CreateDrippingsSchedulings < ActiveRecord::Migration[7.0]
  def change
    create_table :drippings_schedulings do |t|
      t.string :name, null: false
      t.references :resource, polymorphic: true, null: false, index: true
      t.datetime :processed_at
      t.timestamps
      t.index %i[name resource_id resource_type], name: :index_drippings_schedulings_on_name_and_resource
    end
  end
end
