# Rsync

特定の拡張子だけ対象にする

```
rsync -avz --include "*/" --include "*.csv" --exclude "*" foo/ host:foo/
```

- http://tech.nitoyon.com/ja/blog/2013/03/26/rsync-include-exclude/

ファイルのチェックサムだけを比較する（タイムスタンプを見ない）

```
rsync -crlpgoDv foo/ bar/
```

特定のディレクトリ(pub,sys)だけ転送する(bash)

```
rsync -avz ./{pub,sys} host:foo/
```

特定のディレクトリ(log,tmp)を除外して転送する

```
rsync -crlpgoDvn --exclude 'log' --exclude 'tmp' foo/ bar/
```
