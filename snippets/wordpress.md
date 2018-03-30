# wordpress

## install
aptでも入手可能ですが、バージョンが少し古くなるようです。
また、wp-contentの権限を調整したり、wp-config.phpを自分で用意したりと、手間はあんまり変わりません。以下の手順(公式サイトのzipを展開)がオススメです。

公式サイトからzipを入手し、適当なディレクトリ (/var/www/wordpressなど)に展開します。

https://ja.wordpress.org

```
wget https://ja.wordpress.org/wordpress-4.9-ja.zip
```

新しいWordpress(4.9以降?)では、インストーラの中で言語を選ぶことも出来ます。今後はこちらでも良いかも。
Ubuntuで`/var/www/wordpress`にインストールする手順(例)も一緒に。
```
wget https://wordpress.org/latest.zip
cd /var/www/ && sudo unzip ~/latest.zip
chown -R ubuntu:ubuntu wordpress
cd wordpress
chmod 777 wp-content
touch .htaccess && chmod 606 .htaccess
mysql -e "create database wordpress"
```

必要なパッケージを追加します。vsftpdは本体やプラグインの更新に利用します。
sendnamilはリマインドメールなどの送信に利用されます。
```
apt install php-gd php-mbstring php-mysql libapache2-mod-php vsftpd sendmail
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


自作のテーマ内に置いたファイルを参照するには以下の関数を使用します。
子テーマを使って居る場合、templateだと親、stylesheetだと子のパスが返ってきます。

```
get_template_directory_uri() => /wp-content/themes/parent
get_stylesheet_directory_uri() => /wp-content/themes/child
```

https://developer.wordpress.org/reference/functions/get_template_directory_uri/
https://developer.wordpress.org/reference/functions/get_stylesheet_directory_uri/

## plugins

https://wordpress.org/plugins/wp-slimstat/ - アクセスログ
https://wordpress.org/plugins/jetpack/ - アクセスログやSNSとの連携
