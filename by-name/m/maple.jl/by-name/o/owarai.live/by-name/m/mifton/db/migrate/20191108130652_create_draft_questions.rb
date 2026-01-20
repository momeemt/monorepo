class CreateDraftQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :draft_questions do |t|
      t.integer :contest_id
      t.string :title
      t.string :writer
      t.integer :score
      t.text :content
      t.text :constraints
      t.text :input_example
      t.text :output_example
      t.text :answer
      t.timestamps
    end
  end
end
