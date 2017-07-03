t=Time.now
admin = User.create(email:'info@lmlab.net', password:'secret',confirmed_at:t)
Device.create(id: 1, temp_min: 12, temp_max: 28, user:admin, token4write: 'secret')

if Rails.env == 'development'
	t = Time.now - 1.day
	100.times do
		Temp.create(device_id: 1, dt: t, temperature: rand(100..300)/10.0)
		t += 10.minutes
	end
	Address.create(device_id: 1, address: 's-kai@lumber-mill.co.jp', active: true)

	u1 = User.create(email:'test@lmlab.net', password:'secret',confirmed_at:t)

	t = Time.now - 1.day
	100.times do
		Temp.create(device_id: 2, dt: t, temperature: rand(100..300)/10.0)
		t += 10.minutes
	end
	Device.create(id: 2, temp_min: 5, temp_max: 35, user:u1, token4write: 'secret2')
	Address.create(device_id: 2, address: 'y-itou@lumber-mill.co.jp', active: true)
	# Address.create(device_id: 2, mail: '+8190********', active: true)
end
