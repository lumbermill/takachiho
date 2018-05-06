u = User.create(email: "info@lmlab.net", name: "Admin", password:"secret", confirmed_at: Time.now)

require 'barby/barcode/ean_13'

def add_cd(code)
  c = 200000000000 + code.to_i # 12桁インストア
  b = Barby::EAN13.new(c.to_s)
  b.to_s
end

Dir.glob("db/seeds/*.tsv").each do |t|
  print "Loading "+t+" .. "
  n = 0
  open(t).each do |line|
    row = line.split("\t")
    c = t == "db/seeds/amway.tsv" ? add_cd(row[0]) : row[0]
    Item.create(code: c, user_id: u.id, name: row[1])
    n += 1
  end
  puts "Ok. (#{n})"
end
