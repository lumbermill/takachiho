# wordpress

## install

公式サイトからzipを入手し、適当なディレクトリ (/var/www/wordpressなど)に展開します。

```
wget https://ja.wordpress.org/wordpress-4.9-ja.zip
```

データベースを作成しておきます。

```
create database foo;
```

vsftpdをインストールします。本体やプラグインの更新に利用します。

```
apt install vsftpd
```

wp-contentフォルダに書き込みを許可します。

```
chmod 777 wp-content
```

/etc/vsftpd.confを編集し、書き込みを許可します。

```
write_enable=YES
```


```
letsencrypt -d example.com
```

## themes

https://bizvektor.com/
