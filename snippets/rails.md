# Ruby on Rails

## SQLを直接実行する
```
results = ActiveRecord::Base.connection.select_all(sql)
results.to_a
# => [ {"name" => "Joe",   "email" => "joe@example.com"},
#      {"name" => "Alice", "email" => "alice@example.com"},
#      {"name" => "Bob",   "email" => "bob@example.com"} ]
```

更新系のクエリを実行する場合（更新件数は得られない…？）
```
ActiveRecord::Base.connection.execute(sql)
```

## for Ubuntu
```
sudo apt install ruby-devise
rails new railsapp --database=mysql
```

bundleのインストールが失敗するので、aptでパッケージを追加し、そのバージョンに合わせています。
``` Gemfile
gem 'devise', '~> 3.5'
gem 'rmagick', '~> 2.15'
gem 'twitter-bootstrap-rails', '~> 3.2', '>= 3.2.2'
```

## railsプロジェクトを新規作成
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
