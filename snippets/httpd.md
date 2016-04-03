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
