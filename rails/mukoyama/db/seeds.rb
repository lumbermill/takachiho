t=Time.now
admin = User.create(email:'info@lmlab.net', password:'secret',confirmed_at:t)

if Rails.env == 'development'
	p1 = File.read("#{Rails.root}/app/assets/images/IMG_0983.jpg")
	Device.create(id: 1, name: "温度センサ", temp_min: 12, temp_max: 28, user:admin, token4write: 'secret', picture: p1)
	t = Time.now - 3.day
	430.times do
		Temp.create(device_id: 1, dt: t, temperature: rand(100..300)/10.0, humidity: 80.2, illuminance: rand(20..500), voltage: rand(40..50)/10.0)
		t += 10.minutes
	end
	Address.create(device_id: 1, address: 's-kai@lumber-mill.co.jp', active: true)

	u1 = User.create(email:'test@lmlab.net', password:'secret',confirmed_at:t)

	p2 = File.read("#{Rails.root}/app/assets/images/IMG_2806.jpg")
	Device.create(id: 2, name: "市街カメラ", temp_min: 5, temp_max: 35, user:u1, token4write: 'secret2', picture: p2)
	t = Time.now - 1.day
	100.times do
		Temp.create(device_id: 2, dt: t, temperature: rand(100..300)/10.0)
		t += 10.minutes
	end
	Address.create(device_id: 2, address: 'y-itou@lumber-mill.co.jp', active: true)
	# Address.create(device_id: 2, mail: '+8190********', active: true)

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
