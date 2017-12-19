# iptables

特定のポートへのの接続を許可する

```
iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT
```



