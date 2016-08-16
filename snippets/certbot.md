# Certbot

## Install
https://certbot.eff.org/

```
sudo yum install epel-release
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
./certbot-auto
```


## Renew

```
.//certbot-auto renew --quiet
```

certonlyオプションを使って手動でインストールした場合、renewも手動で行う必要があります。

```
./certbot-auto certonly -d lumber-mill.co.jp
```

/etc/letsencrypt/live に lumber-mill.co.jp-0001 というフォルダが生成されるので、
これを lumber-mill.co.jp（既存の参照フォルダ）にリネームします。Webサーバを再起動すれば
新しい証明書が参照されるようになります。
