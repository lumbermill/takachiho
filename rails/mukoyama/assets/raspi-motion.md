# RaspberryPi + motion

下記URLのドキュメントを参考にRaspberryPiをセットアップします。

<https://github.com/koki-h/motion_for_mukoyama>

以下は設定の抜粋です（詳細は上記URLを）。

```
sudo apt install -y motion
git clone https://github.com/koki-h/motion_for_mukoyama.git
```

/etc/modules

```
bcm2835-v4l2
```

/boot/config.txt

```
start_x=1
gpu_mem=128
disable_camera_led=1
```

motion_for_mukoyama/mukoyama.conf.sampleを複製して、mukoyama.confを作成し、IDやTOKENを設定します。各デバイスの設定画面から必要な情報を取得してください。

/etc/rc.local

```
cd /home/pi/motion_for_mukoyama && ./bin/start.sh
```

```
sudo reboot
```
