class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|

      t.string :title
      t.string :writer
      t.integer :score


      t.text :content
      t.text :constraints # 制約
      t.text :input_example
      t.text :output_example

      t.text :answer


      t.timestamps
    end
  end
end
