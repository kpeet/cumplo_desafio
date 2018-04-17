class CreateUfs < ActiveRecord::Migration[5.2]
  def change
    create_table :ufs do |t|
      t.datetime :fecha_consultada
      t.float :valor

      t.timestamps
    end
  end
end
