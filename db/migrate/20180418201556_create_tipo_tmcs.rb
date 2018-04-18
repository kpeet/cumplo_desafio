class CreateTipoTmcs < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_tmcs do |t|
      t.string :subtitulo
      t.string :titulo
      t.integer :id_tipo

      t.timestamps
    end
  end
end
