# -*- coding:utf-8; -*-

【ビルド】
・該当ディレクトリ(Makefile, extract_vec.cc, create_vec.ccの存在するディレクトリ)にて、make を実行して、ビルドしてください。
    $ unzip vec_util_*.zip
    $ cd vec_util
    $ make
  extract_vec, create_vec が生成されます。
・opencv, opencv-devel, make, gcc, gcc-c++ などがインストールされている必要があります(環境によっては、他にもインストールが必要なパッケージが存在するかもしれません)。



【分解】
・指定された vec ファイル内に格納されている、画像ファイルをすべて抽出します。
・コマンド実行時のカレントディレクトリに img_00000.png 〜 通し番号で、格納されている画像ファイルをすべて出力します。
・コマンド名は，extrace_vec で、引数なしで実行すると、使用方法が表示されます。
Usage: extract_vec [options] <vec filename>
        --width=width   default=24
        --height=height default=24
        --type=png|jpg  default=png
・コマンドの実行例は、下記のようになります。
    $ ./extract_vec -w 44 -h 18 -t png test.vec
    $ ./extract_vec -w 44 -h 18 -t jpg test.vec
・出力される画像ファイルは、カレントディレクトリに出力され、同一ファイル名が存在していた場合は、上書きされます。
・vec ファイルに格納されている画像ファイルの縦横サイズは、指定していただく必要があります(vec ファイル内には、縦×横のピクセル数の情報しか格納されていません)。指定されたサイズ(縦×横)と格納されているピクセル数が一致しない場合は、エラーが出力されます。


【構築】
・新しく vec ファイルを生成し、指定された画像ファイルをすべて格納します。
・コマンド名は、create_vec で、引数なしで実行すると、使用方法が表示されます。
Usage: create_vec [options] <image filenames ...>
        --width=width   default=24
        --height=height default=24
        --vec=vecfilename       default=output.vec
・コマンドの実行例は、下記のようになります。
    $ ./create_vec -w 44 -h 18 -v output.vec img_*.png
・コマンドラインで、指定する画像ファイル名は、複数ファイル指定することが可能です。
・格納する画像ファイルは、強制的に指定されたサイズで統一されます。この時、画像ファイルの縦横比は考慮せずに、リサイズされます。
・指定する画像ファイルは、png, jpg など、opencv がサポートしている物であれば、格納可能だと思います。
