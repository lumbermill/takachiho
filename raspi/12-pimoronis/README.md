# Pimoroni

ライブラリのインストールに、`pimoroni-dashboard`コマンドを使用します。
メニューから手元にあるボードを選択するだけで必要な作業を完了してくれます。

```
sudo apt install pimoroni
pimoroni-dashboard
```

ホームディレクトリ直下(`/home/pi/Pimoroni`)に、各ボードのドキュメントやサンプルプログラムも置かれますので、
これを参考にしながら自身のプログラムを書いていくことが可能です。

I2Cインタフェースがうまく認識されない場合、下記のコマンドから有効化をしてみてください。

```
sudo raspi-config
```

[pHAT Stack Configurator](https://pinout.xyz/phatstack)を使うと、複数のボードを共存可能かどうか調べることができます。

- [RaspberryPi入門](https://lmlab.net/books/2102_raspi/index.html)
