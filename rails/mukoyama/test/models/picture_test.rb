require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  setup do
    # fixtureの書き方がわからないのでここで初期データを入れる
    t = Time.now - 1.day
    100.times do
      Temp.create(device_id: 2, dt: t, temperature: rand(100..300)/10.0)
      t += 10.minutes
    end
    Address.create(device_id: 2, address: 'y-itou@lumber-mill.co.jp', active: true)

    pictures = []
    pictures += [File.read("#{Rails.root}/app/assets/images/170708_095838.jpg")]
    pictures += [File.read("#{Rails.root}/app/assets/images/170708_124515.jpg")]
    pictures += [File.read("#{Rails.root}/app/assets/images/170708_141843.jpg")]
    pictures += [File.read("#{Rails.root}/app/assets/images/170708_142133.jpg")]
    pictures.each do |p|
      Picture.create(device_id: 2, dt: t, data:p)
      t += 10.minutes
    end
    seeds = ["109058.jpg","109077.jpg","109091.jpg","109093.jpg","109094.jpg","109096.jpg","109015.jpg"]
    t -= 1.days
    seeds.each do |s|
      Picture.create(device_id: 2, dt: t, data:File.read("#{Rails.root}/db/seeds/#{s}"))
      t += 10.minutes
    end
  end

  test "should zip some pictures" do
    device_id = 2
    date = Time.now.strftime("%Y-%m-%d")
    zip_path = Picture.save_to_zip(device_id, date) 
    assert_equal Mukoyama::DOWNLOAD_DIR+"/#{device_id}-#{date}-pictures.zip", zip_path
    assert File.exist?(zip_path)
  end

  test "should raise exception if no pictures found" do
    device_id = 3
    date = Time.now.strftime("%Y-%m-%d")
    ex = assert_raises{
      Picture.save_to_zip(device_id, date) 
    }
    assert_equal("No Pictures found.", ex.message)
  end
end

