class CreateQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :queries do |t|
      t.string  :fd_algorithm          # 特徴点検出アルゴリズム
      t.string  :de_algorithm          # 特徴量記述アルゴリズム
      t.string  :option_name           # アルゴリズムオプション名
      t.string  :version               # システムバージョン番号(初期値は0.0.0 訓練データの差し替え等があった場合も更新する)
      t.string  :query_image_path      # 質問画像のファイルパス
      t.integer :query_keypoints_count # 質問画像から検出された特徴点の数
      t.time    :query_datetime        # 検出処理実行時刻
      t.timestamps
    end
  end
end
