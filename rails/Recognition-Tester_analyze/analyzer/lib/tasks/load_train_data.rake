require 'csv'
namespace :load_train_data do
  desc "訓練データ（ラベル情報・JANコード）をCSVファイルから読み込む"
  task :load => :environment do
    train_data_csv_path = "#{APP_CONFIG["train_image_dir"]}/item_list.txt"
    puts "#{train_data_csv_path} から訓練データを読み込みます.."
    insert_count = 0
    CSV.foreach(train_data_csv_path) do |row|
      unless TrainDatum.find(row[0])
        td = TrainDatum.new({
          id:    row[0],
          jan:   row[1],
          label: row[2],
        })
        if (td.save)
          insert_count += 1
        else
          puts "読み込みに失敗しました。#{row.inspect}"
        end
      else
          puts "IDが重複しています。#{row.inspect}"
      end
    end
    puts "#{insert_count}行 読み込みました。"
  end
end
