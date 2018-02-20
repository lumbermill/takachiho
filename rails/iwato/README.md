# Project iwato
notesの後継としてデザインしています。（tipsとか汎用的なデータ)


## 初期導入時のメモ

```
rails new iwato --database=mysql
cd iwato
# Add some gems to Gemfile
bundle update
cap install

./bin/rails db:create
./bin/rails g bootstrap:install
./bin/rails generate paper_trail:install  #失敗する
```
