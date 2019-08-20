# Ruby on Rails

## ActiveRecord
### Execute sql directly
```
results = ActiveRecord::Base.connection.select_all(sql)
results.to_a
# => [ {"name" => "Joe",   "email" => "joe@example.com"},
#      {"name" => "Alice", "email" => "alice@example.com"},
#      {"name" => "Bob",   "email" => "bob@example.com"} ]
```

When the query is for updating(inserting). (How to get the number of affected rows?)
```
ActiveRecord::Base.connection.execute(sql)
```

## Use blob as response.
```
response.headers['Content-Length'] = @picture.data.length.to_s
send_data @picture.data, :type => "image/jpeg", :disposition => "inline"
```

## Create new rails project.
```
rails new sandbox-rails --database=mysql
```

``` Gemfile
gem 'therubyracer', platforms: :ruby
gem 'devise', '~> 4.0'
gem 'rmagick', '~> 2.15'

gem 'twitter-bootstrap-rails', '~> 3.2', '>= 3.2.2'
```
https://github.com/seyhunak/twitter-bootstrap-rails

```
rails generate bootstrap:install static
```
http://www.lumber-mill.co.jp/notes/tips/141006_ruby.html

## ルーティングエラー
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

## Returns specific http status
head method doesn't work.

```
send_file(Rails.root.join('app', 'assets', 'images', 'no-photo.png'), type: 'image/jpeg', disposition: "inline", status: 404)
```

```
render status:404, text: "Resource not found."
```

## Date(actionsupport)

```
> Time.new(2019,8,20) + 1.month
=> 2019-09-20 00:00:00 +0000
> Time.new(2005,1,1) - 1.week
=> 2004-12-25 00:00:00 +0000
> Time.new(2019,8,20) - Time.new(2019,8,19)
=> 86400.0
```

ISO yearweek

```
> Time.new(2005,1,1).strftime("%G%V")
=> "200453"
> Time.new(2005,1,3).strftime("%G%V")
=> "200501"
```

```
> 1800 * 1.08
=> 1944.0000000000002
> 1800 * Rational("1.08")
=> (1944/1)
> 1800 * BigDecimal("1.08")
=> 0.1944e4
```

## Misc

```
"this is a pen.".truncate(20)
```
