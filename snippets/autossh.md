# autossh

Install.
```
sudo apt get install autossh
```

Launch on /etc/rc.local
```
sudo -u pi autossh -f -N -R 10022:localhost:22 -p 123 user@example.net
```
