admin = User.create(email:'info@lmlab.net', password:'secret')

if Rails.env == 'development'
	t=Time.now
	100.times do
		TmprLog.create(raspi_id: 1, time_stamp: t, temperature: rand(100..300)/10.0)
		t += 10.minutes
	end
	Address.create(raspi_id: 1, mail: 's-kai@lumber-mill.co.jp', active: true)
	Setting.create(raspi_id: 1, min_tmpr: 12, max_tmpr: 28, user:admin)

	u1 = User.create(email:'test@lmlab.net', password:'secret')

	t=Time.now
	100.times do
		TmprLog.create(raspi_id: 2, time_stamp: t, temperature: rand(100..300)/10.0)
		t += 10.minutes
	end
	Address.create(raspi_id: 2, mail: 'y-itou@lumber-mill.co.jp', active: true)
	Setting.create(raspi_id: 2, min_tmpr: 5, max_tmpr: 35, user:u1)
end
