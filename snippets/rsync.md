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
