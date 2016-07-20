# Recognition-Testerの認識結果を分析するアプリ
## 動作環境
```
$ cat /etc/issue
Ubuntu 16.04 LTS \n \l

$ ruby -v
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]

$ rails -v
Rails 5.0.0

$ sudo apt install sqlite3
$ sudo apt install libsqlite3-dev
$ cd analyzer
$ vi Gemfile # 17行目の "# gem 'therubyracer', platforms: :ruby"のコメントを外す
$ bundle install
```
