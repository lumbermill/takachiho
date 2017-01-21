#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create(email: "info@lmlab.net", name: "Admin", password:"secret", confirmed_at: Time.now)

Dir.glob("db/seeds/*.tsv").each do |t|
  print "Loading "+t+" .. "
  n = 0
  open(t).each do |line|
    row = line.split("\t")
    Item.create(code: row[0], user_id: u.id, name: row[1])
    n += 1
  end
  puts "Ok. (#{n})"
end
