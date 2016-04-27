# Raspberry Pi 3用SDカード作成 #
NOOBSからOSのインストールをした場合、電源投入時に虹色の画面から進まない現象が起こることがあります。  
.imgからOSのインストールをすることで回避できる可能性があります。

```sh
$ df
Filesystem    512-blocks      Used Available Capacity  iused    ifree %iused  Mounted on
/dev/disk1     974716928 207824184 766380744    22% 26042021 95797593   21%   /
devfs                366       366         0   100%      634        0  100%   /dev
map -hosts             0         0         0   100%        0        0  100%   /net
map auto_home          0         0         0   100%        0        0  100%   /home
/dev/disk2s1              7.3Gi  992Ki  7.3Gi     1%        0          0  100%   /Volumes/UNTITLED

$ sudo diskutil umount /dev/disk2s1 # or $ sudo diskutil umount /volumes/UNTITLED
Volume UNTITLED on disk2s1 unmounted

$ sudo dd bs=1m if="./raspbian.img" of="/dev/rdisk2"
3125+0 records in
3125+0 records out
3276800000 bytes transferred in 471.302287 secs (6952650 bytes/sec)
```

### ddコマンド引数解説 ###
- bs=1m  
  １度に読み書きするデータの量を指定しています。デフォルトでは512倍とと小さい値となっているため、1MBを指定しています。  

- if="./raspbian.img"  
  .imgのパスを指定してください。

- or="/dev/rdisk2"  
  /dev/disk2に書き込む場合、/dev/rdisk2を指定します。  
  この`r`は、SDカードにアンバッファモードで書き込むための指定です。  
  rをつけない場合はバッファモードとなり書き込みが非常に遅くなるそうです。(未検証)  
  /dev/disk2s1の`s1`は、/dev/disk2のパーティションの1番目を指しています。  
