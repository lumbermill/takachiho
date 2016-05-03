# Apache httpd

```
NameVirtualHost *:80

<VirtualHost *:80>
  ServerName xyz.lmlab.net
  DocumentRoot /var/www/xyz.lmlab.net/public
  ErrorLog logs/xyz.lmlab.net-error_log
  CustomLog logs/xyz.lmlab.net-access_log common
</VirtualHost>

<VirtualHost *:80>
  SetEnv SECRET_KEY_BASE 
  SetEnv FACEBOOK_APP_SECRET 
  ServerName xyz.lmlab.net
  DocumentRoot /var/www/xyz.lmlab.net/public
  PassengerAppEnv production
  ErrorLog logs/xyz.lmlab.net-error_log
  CustomLog logs/xyz.lmlab.net-access_log common
</VirtualHost>
```

```
Listen 443
LoadModule ssl_module modules/mod_ssl.so
SSLPassPhraseDialog builtin
SSLSessionCache shmcb:/var/cache/mod_ssl/scache(512000)
SSLSessionCacheTimeout 300
SSLMutex default
SSLRandomSeed startup file:/dev/urandom 256
SSLRandomSeed connect builtin
SSLCryptoDevice builtin

<VirtualHost *:443>
    LogLevel warn
    SSLEngine on
    SSLProtocol all -SSLv2
    SSLCipherSuite ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW

    SSLCertificateFile /etc/pki/tls/certs/ssl.lmlab.asia.crt
    SSLCertificateKeyFile /etc/pki/tls/private/ssl.lmlab.asia.key

    SetEnvIf User-Agent ".*MSIE.*" \
         nokeepalive ssl-unclean-shutdown \
         downgrade-1.0 force-response-1.0

    CustomLog logs/ssl.lmlab.asia-request_log \
          "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"
    ErrorLog logs/ssl.lmlab.asia-error_log
    TransferLog logs/ssl.lmlab.asia-access_log

    ServerName ssl.lmlab.asia
    ServerAdmin info@ssl.lmlab.asia
    DocumentRoot /opt/ssl.lmlab.asia/pub
    Alias /res /opt/ssl.lmlab.asia/res
    php_value display_errors 1
</VirtualHost>
```

BASIC認証
```
<VirtualHost ..:80>
  ServerName lmlab.net
  DocumentRoot /var/www/html

  <Directory /var/www/html>
    AuthType Basic
    AuthName "Protected Area"
    AuthUserFile /var/www/htpasswd
    AuthGroupFile /dev/null
    Require valid-user
  </Directory>
</VirtualHost>
```
