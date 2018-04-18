class CreateTmcs < ActiveRecord::Migration[5.2]
  def change
    create_table :tmcs do |t|
      t.string :subtitulo
      t.date :fecha
      t.float :valor
      t.integer :tipo
      t.string :titulo

      t.timestamps
    end
  end
end
