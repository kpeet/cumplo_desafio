class CreateDolars < ActiveRecord::Migration[5.2]
  def change
    create_table :dolars do |t|
      t.datetime :fecha_consultada
      t.float :valor

      t.timestamps
    end
  end
end
