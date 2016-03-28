# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env == 'development'
	t=Time.now

	100.times do
		TmprLog.create(raspi_id: 1, time_stamp: t, temperature: rand(100..300)/10.0)
		t += 10.minutes
	end

	Address.create(raspi_id: 1, mail: 's-kai@lumber-mill.co.jp', active: true)

	Setting.create(raspi_id: 1, min_tmpr: 12, max_tmpr: 28)
end
