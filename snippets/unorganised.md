# Swift
```
let i = 1
let f = CGFloat(i)
```

```
class User {
    var name: String
    var score: Int = 0
    init(name: String) {
        self.name = name
    }
    // final
    func upgrade() {
        score++
    }
}

class AdminUser: User {
    func reset() {
        score = 0
    }
    override func upgrade() {
        super.upgrade()
        score += 3
    }
} 

var tom = User(name: "Tom")
tom.name
tom.score
tom.upgrade()
tom.score

var bob = AdminUser(name: "Bob")
bob.name
bob.score
bob.upgrade()
bob.score
bob.reset()
bob.score
```


```
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {

  // バックグラウンド処理

  dispatch_async(dispatch_get_main_queue(), ^{
    // UIの更新処理
  });
});
```


let d = ["taguchi": 500, "fkoji": 800]
for (k, v) in d {
    println("key:\(k) val:\(v)")
}



String(format: "%04d", [])



func shuffle<T>(inout array: [T]) {
    for var j = array.count - 1; j > 0; j-- {
        var k = Int(arc4random_uniform(UInt32(j + 1))) // 0 <= k <= j
        swap(&array[k], &array[j])
    }
}
# Python
```
#! /usr/bin/python
# -*- coding: utf8 -*-
```


import time

started = time.time()
elapsed = time.time() - started // second


import datetime

datetime.datetime.now().strftime("%F %T")
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



# MySQL
```
CREATE TABLE t (
id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
v VARCHAR(255) NOT NULL DEFAULT '',
modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
UNIQUE KEY (v)
FOREIGN KEY v REFERENCES tt(v)
)ENGINE=InnoDB, CHARACTER SET=utf8;
```
```
GRANT ALL ON db.* TO 'user'@'%' IDENTIFIED BY 'pass';
GRANT REPLICATION SLAVE ON *.* TO 'user'@'host' IDENTIFIED BY 'pass';
```
```
LOAD DATA INFILE '/tmp/.csv' REPLACE INTO TABLE journals_raw IGNORE 1 LINES;
```


# Bash
```
^[ + b - previous word
^[ + f - next word

^[ + . - insert previous return value



PORT=${1:-52}

for I in $(seq -w 1 31)
do
  echo $I
done

date +%y%m%d_%H%M%S
```

# Rsync

```
# bar.csvだけ
rsync -avz --include "*/" --include "bar.csv" --exclude "*" foo/ host:foo/
```

http://tech.nitoyon.com/ja/blog/2013/03/26/rsync-include-exclude/


# Move svn to git
$ git svn clone svn+ssh://sakura09.lumber-mill.co.jp/repos/kanesue.svn/eclipse/trunk/kanesue_eos --authors-file=crashed/users_for_git.txt --no-metadata

$ svn rm svn+ssh://sakura09.lumber-mill.co.jp/repos/kanesue.svn/eclipse/trunk/kanesue_eos

svn log -r {2015-10-11}:HEAD svn+ssh://sakura09/repos/kanesue.svn

Wordpress plugins
Google Analytics by Yoast 5.3.3
Materials

Image materials
http://www.sitebuilderreport.com/stock-up
http://www.pexels.com/
.vimrc
syntax on
autocmd FileType python setl tabstop=4 shiftwidth=4 expandtab
autocmd FileType ruby setl tabstop=2 shiftwidth=2 expandtab
autocmd FileType eruby setl tabstop=2 shiftwidth=2 expandtab
