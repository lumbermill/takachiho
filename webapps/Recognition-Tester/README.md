(この文書は書きかけです。情報が不完全ですので参考にしないで下さい。)
# Recognition-Tester
## このプログラムについて
このプログラムは 「WEB+DB PRESS Vol83」の特集記事「[実践]画像認識」のサンプルコードをベースとした画像認識システムです。

作者様((有)来栖川電算 山口陽平様)の許諾を得て開発を開始しました。

オリジナルは以下よりダウンロードできます。

http://gihyo.jp/magazine/wdpress/archive/2014/vol83/support

## 使い方
### 必要なソフトウェア
- Java1.8
- OpenCV3.1

### 必要なソフトウェアをインストール
#### Mac
```
$ brew opencv3 --with-java
```

#### Linux (Ubuntu)
```
```
- OpenCV3.1のインストール手順は以下を参考にしました。
 - https://blog.kevin-brown.com/programming/2014/09/27/building-and-installing-opencv-3.html

### ソースコードをcron

### OpenCVライブラリをシステムディレクトリにコピー
#### Mac
```
$ cd /path/to/Recognition-Tester
$ cp /usr/local/Cellar/opencv3/3.1.0_3/share/OpenCV/java/libopencv_java310.so ./libs/
$ cp /usr/local/Cellar/opencv3/3.1.0_3/share/OpenCV/java/opencv-310.jar ./libs/
$ mv ./libs/libopencv_java310.so ./libs/libopencv_java310.dylib
```

#### Linux (CentOS7)

### サーバ起動
プログラムが配置されたディレクトリ（build.gradleのあるディレクトリ）で
``` $ ./gradlew run& ``` すると
自動的にソースコードがコンパイルされ、httpサーバがポート番号8080で起動します。
