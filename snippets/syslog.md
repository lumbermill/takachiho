

(標準及びエラー)出力をsyslogにリダイレクトします。
```
echo "Hello, world." 2>&1 | logger -p cron.info -t "hello"
```

cron.infoの部分は、facility.levelという書式になっており、他にも `user` や `local7` 、
`err` や `warning` などの値を指定することができます。完全なリストは logger コマンドのマニュアルを参照してください。
