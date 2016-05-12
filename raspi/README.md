# Raspberry Pi 3用SDカード作成 #
NOOBSからOSのインストールをした場合、電源投入時に虹色の画面から進まない現象が起こることがあります。  
.imgからOSのインストールをすることで回避できる可能性があります。

```sh
$ df
Filesystem    512-blocks      Used Available Capacity  iused    ifree %iused  Mounted on
/dev/disk1     974716928 207832504 766372424    22% 26043061 95796553   21%   /
devfs                379       379         0   100%      657        0  100%   /dev
map -hosts             0         0         0   100%        0        0  100%   /net
map auto_home          0         0         0   100%        0        0  100%   /home
/dev/disk2s1    15511552      5056  15506496     1%       79   242289    0%   /Volumes/Untitled

$ sudo diskutil umount /dev/disk2s1 # or $ sudo diskutil umount /Volumes/Untitled
Volume Untitled on disk2s1 unmounted

$ sudo dd bs=1m if="./raspbian.img" of="/dev/rdisk2"
3847+0 records in
3847+0 records out
4033871872 bytes transferred in 375.941411 secs (10730055 bytes/sec)

$ sudo diskutil umount /dev/disk2s1
Volume boot on disk2s1 unmounted
```

### ddコマンド引数解説 ###
- bs=1m  
  １度に読み書きするデータの量を指定しています。デフォルトでは512byteと小さい値となっているため、1MBを指定しています。  

- if="./raspbian.img"  
  .imgのパスを指定してください。

- or="/dev/rdisk2"  
  /dev/disk2に書き込む場合、/dev/rdisk2を指定します。  
  この`r`は、SDカードにアンバッファモードで書き込むための指定です。  
  rをつけない場合はバッファモードとなり書き込みが非常に遅くなるそうです。(未検証)  
  /dev/disk2s1の`s1`は、/dev/disk2のパーティションの1番目を指しています。  
