# Swift
キャストする方法。
```
let i = 1
let f = CGFloat(i)
```

クラスの定義、継承。
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

バックグラウンド処理。
```
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {

  // バックグラウンド処理

  dispatch_async(dispatch_get_main_queue(), ^{
    // UIの更新処理
  });
});
```

ハッシュのイテレート。
```
let d = ["taguchi": 500, "fkoji": 800]
for (k, v) in d {
    println("key:\(k) val:\(v)")
}
```

文字列のフォーマット。
```
String(format: "%04d", [])
```

シャッフル。
```
func shuffle<T>(inout array: [T]) {
    for var j = array.count - 1; j > 0; j-- {
        var k = Int(arc4random_uniform(UInt32(j + 1))) // 0 <= k <= j
        swap(&array[k], &array[j])
    }
}
```

if letとguard let。
```
if let a = …, b = … {
  a.something
  b.something
}

guard let a = …, b = … else {
	throw AnError
}
```

Optionalがnilを返した場合の初期値を与える方法
```
let number: Int = Int(str) ?? 999
let name = user?.name ?? "no name"
```
