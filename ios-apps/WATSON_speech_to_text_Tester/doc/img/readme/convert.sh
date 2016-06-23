src=$1
dest=${src%.*}_s.jpg
echo $dest
convert -geometry x500 -border 1x1 -bordercolor "#000000" $src $dest
