# Design Pattern in Ruby
結城浩「Java言語で学ぶデザインパターン入門」のサンプルプログラムをRubyに移植したコードです。オリジナルのコード(Java)は著者のサイトから入手可能です。

http://www.hyuki.com/dp/

起業してしばらくはJava一筋で頑張ってきましたが、徐々に限界を感じるようになってきました。最近ではRubyやPython,PHPを触ることが多いです。

## 目次
上記参考書籍の目次の抜粋です。

```
Iterator－－1つ1つ数え上げる
Adapter－－一皮かぶせて再利用

Template Method－－具体的な処理をサブクラスにまかせる
Factory Method－－インスタンス作成をサブクラスにまかせる

Singleton－－たった1つのインスタンス
Prototype－－コピーしてインスタンスを作る
Builder－－複雑なインスタンスを組み立てる
Abstract Factory－－関連する部品を組み合わせて製品を作る

Bridge－－機能の階層と実装の階層を分ける
Strategy－－アルゴリズムをごっそり切り替える

Composite－－容器の中身の同一視
Decorator－－飾り枠と中身の同一視

Visitor－－構造を渡り歩きながら仕事をする
Chain of　Responsibility－－責任のたらい回し

Facade－－シンプルな窓口
Mediator　相手は相談役一人だけ

Observer－－状態の変化を通知する
Memento－－状態を保存する
State－－状態をクラスとして表現する

Flyweight－－同じものを共用して無駄をなくす
Proxy－－必要になってから作る

Command－－命令をクラスにする
Interpreter－－文法規制をクラスで表現する
```

## メモ
インタフェースは全て決してダックタイピングスタイルに
実行時まで分からない、でもその方がいい。

attr_accessor

require_relative の方法。

## まとめてロード(reqire)する
```
Dir[File.expand_path('../commands', __FILE__) << '/*.rb'].each do |file|
  require file
end
```
http://kurochan-note.hatenablog.jp/entry/2014/02/15/235706

### to_i か Integer か？
to_iを使うと、数値に変換できない文字列は「0」として扱われます。不正な文字が入った時にはエラーとして処理したい場合には、以下のような構文を利用します。

```
Integer(current_token)
```

### printメソッドを使っている場合
```
Kernel.print
```

### 静的なコンストラクタ
```
class Foo
  class << self
    def setup
      puts "static init"
    end
  end
  setup

  def initialize
    puts "instance init"
  end
end
Foo.new
```
### Rubyのリフレクション
```
cls = eval "String"
str = cls.new("123")
str.send("to_i") # => 123
```

### TclTk
```
sudo apt-get install ruby2.1-tcltk
```

```
scrot -s -b
```

http://www.tkdocs.com/
http://ruby-doc.org/stdlib-2.0.0/libdoc/tk/rdoc/TclTk.html
