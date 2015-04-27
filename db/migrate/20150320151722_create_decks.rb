class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :topic
    end
  end
end
