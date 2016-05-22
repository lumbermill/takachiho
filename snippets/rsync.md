# Rsync

```
# bar.csvだけ
rsync -avz --include "*/" --include "bar.csv" --exclude "*" foo/ host:foo/
```

http://tech.nitoyon.com/ja/blog/2013/03/26/rsync-include-exclude/

ファイルのチェックサムだけを比較する（タイムスタンプを見ない）。
```
rsync -crlpgoDv foo/ bar/
```

特定のディレクトリ(pub,sys)だけ転送する。
```
rsync -avz ./{pub,sys} host:foo/
```
