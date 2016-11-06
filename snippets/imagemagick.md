# ImageMagick

## Resize
フォルダ内のBMPファイルのサイズを20%に縮小しつつ、JPG形式に変更します。変更後のファイル名は「img-000.jpg」といった形でナンバリングされます。

```
$ convert *.bmp -resize 20%x20% img-%03d.jpg
```
指定したファイル（foo.jpg）を100x100pxの枠に収まるようにリサイズして別のファイル（bar.jpg）に保存します。
```
$ convert foo.jpg -resize 100x100 bar.jpg
```

100x100より小さいサイズの画像を拡大したくない場合は、「>」を付けます。
```
$ convert foo.jpg -resize "100x100>" bar.jpg
```

上記処理をカレントディレクトリ以下の全てのjpgファイルに対して実施したい場合はfindコマンドと組み合わせて以下のように記述できます。
```
$ find . -name "*.jpg" -exec convert -resize 300x300 {} {} \\;
```


# Grayscale
カレントディレクトリ内の全てのjpgファイルをグレースケール化するは-typeオプションを指定します。
```
$ find . -name "*.jpg" -exec convert -type grayscale {} {} \;
```

# Remove EXIF information
```
convert -strip foo.jpg bar.jpg
```

# Rotate
時計回りに90度回転させます。
```
convert -rotete 90 foo.jpg bar.jpg
```

# Trim
周辺の余白を切り取ります。
```
convert -fuzz 20% -trim foo.jpg bar.jpg
```

# Script
ワイルドカードやfindコマンドでもある程度の自動化は可能ですが、もっと細かい条件を付けたい場合の
スクリプトの例です。カレントディレクトリ内の.jpgファイルを変換してoutディレクトリに格納します。

```
# Converts image files in the directory.

BASEDIR="."
OUTDIR="./out"
CONVERT_OPTS="-fuzz 20% -trim -resize 640x640 -strip"

`mkdir -p #{OUTDIR}`
puts "Convert with: "+CONVERT_OPTS

Dir.entries(BASEDIR).each do |f|
  src = BASEDIR+"/"+f
  next unless File.file? src
  next unless f.end_with? ".jpg"
  dst = OUTDIR+"/"+f
  puts f + " -> " +dst
  cmd = "convert #{CONVERT_OPTS} #{src} #{dst}"
  m = `#{cmd}`
  if $? != 0 || !m.empty?
    puts m
  end
end
```
