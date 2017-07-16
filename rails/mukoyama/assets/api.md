# API

データアップロード
```
path: /temps/upload
method: get
params: id, token, time_stamp
params(optional): temperature, pressure, humidity, illuminance, voltage
```

画像アップロード
```
path: /pictures/upload
method: post
params: id, token, time_stamp, file
params(optional): data_type, detected, info
```

## タイムスタンプの書式
```
2017-07-14T23:36:06+00:00
```
