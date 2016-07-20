class CreateCorrectAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :correct_answers do |t|
      t.integer :query_id       # 検出処理ID
      t.integer :train_datum_id # 正解となる訓練データのID
      t.timestamps
    end
  end
end
