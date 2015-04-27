class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :question
      t.string :answer
      t.boolean :played, default: false
      t.references :deck
    end
  end
end
