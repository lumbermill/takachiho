# wordpress

## install

公式サイトからzipを入手し、適当なディレクトリ (/var/www/wordpressなど)に展開します。

https://ja.wordpress.org

```
wget https://ja.wordpress.org/wordpress-4.9-ja.zip
```

データベースを作成しておきます。

```
create database foo;
```

必要なパッケージを追加します。vsftpdは本体やプラグインの更新に利用します。
sendnamilはリマインドメールなどの送信に利用されます。
```
apt install vsftpd php-gd php-mysql libapache2-mod-php vsftpd sendmail
```

wp-contentフォルダに書き込みを許可します。

```
chmod 777 wp-content
touch .htaccess
chmod 606 .htaccess
```

/etc/vsftpd.confを編集し、書き込みを許可します。

```
write_enable=YES
```

SSL化をする場合。
```
letsencrypt -d example.com
```

### パスの書き換えを利用する場合
/etc/apache2/sites-available/000-default-le-ssl.confを編集(ファイル末尾に追記)
```
<Directory /var/www/wordpress/ >
  AllowOverride All
</Directory>
```

mod_rewriteを有効化&apache再起動
```
$ sudo a2enmod rewrite
$ sudo apachectl restart

```
## themes

https://bizvektor.com/ - コーポレートサイトっぽいサイトに
https://wordpress.org/themes/simple-bootstrap/ - シンプルなBootstrapテーマ
