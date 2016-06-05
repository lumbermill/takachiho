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
gem 'devise', '~> 4.0'
gem 'rmagick', '~> 2.15'
```

http://www.lumber-mill.co.jp/notes/tips/141006_ruby.html


```
raise ActionController::RoutingError.new('Not Found')
```

## 列の定義を修正する
```
rails g migration ChangeColInTbl
```

```
change_column :tbl, :col, :string, null: false, default: "", limit: 2000
```

## 言語リソース
```
en:
  hello: "Hello world"
  activerecord:
    models:
      user: 'User'
      setting: 'Setting'
    attributes:
      user:
        name: 'Name'
```
