["../factory","../listfactory","../tablefactory"].each do |d|
  Dir[File.expand_path(d, __FILE__) << '/*.rb'].each { |f| require f }
end

if ARGV.length != 1
  puts "USAGE: #{$0} (Table|List)";
  exit 1
end
factory = Factory.get(ARGV[0])

google = factory.create_link("Google","http://google.com")
microsoft = factory.create_link("Microsoft","http://microsoft.com")
ibm = factory.create_link("IBM","http://ibm.com")
apple = factory.create_link("Apple","http://apple.com")
oracle = factory.create_link("Oracle","http://oracle.com")
amazon = factory.create_link("Amazon","http://amazon.com")
facebook = factory.create_link("Facebook","http://facebook.com")

tray11 = factory.create_tray("Tray 1-1")
tray11.add(ibm)
tray11.add(oracle)

tray1 = factory.create_tray("Tray 1")
tray1.add(tray11)
tray1.add(google)
tray1.add(apple)
tray1.add(facebook)

tray2 = factory.create_tray("Tray 2")
tray2.add(microsoft)
tray2.add(amazon)

page = factory.create_page("MyBookmakrs","Taro Ruby")
page.add(tray1)
page.add(tray2)
page.output

# TODO: attr_reader不要なとこがある？
