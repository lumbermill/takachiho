class CreateTrainData < ActiveRecord::Migration[5.0]
  def change
    # 画像のパスはIDに対応する
    create_table :train_data do |t|
      t.string :jan          # JANコード
      t.string :label        # ラベル
      t.timestamps
    end
  end
end
