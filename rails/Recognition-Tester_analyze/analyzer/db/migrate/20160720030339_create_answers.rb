class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.integer :query_id        # 認識処理(Query)のID
      t.integer :train_datum_id  # 訓練データのID
      t.integer :score           # 認識結果のスコア
      t.float   :similarytyRatio # 特徴点一致率（スコア / 質問画像の特徴点の数）
      t.timestamps
    end
  end
end
