# Ruby on Rails

```
results = ActiveRecord::Base.connection.select_all(sql)
result.to_a
# => [ {"name" => "Joe",   "email" => "joe@example.com"},
#      {"name" => "Alice", "email" => "alice@example.com"},
#      {"name" => "Bob",   "email" => "bob@example.com"} ]
```

```
ActiveRecord::Base.connection.execute(sql)
```

```
$ rails new sandbox-rails --database=mysql
```

```Gemfile
gem 'therubyracer', platforms: :ruby
```

http://www.lumber-mill.co.jp/notes/tips/141006_ruby.html



```
raise ActionController::RoutingError.new('Not Found')
```
