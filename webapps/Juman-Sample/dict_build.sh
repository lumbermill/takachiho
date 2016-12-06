set -eu
HOME_DIR=/home/ubuntu
DICT_SRC_DIR=$HOME_DIR/src_juman/jumanpp-1.01/dict-build/
sudo chmod -R 777 $DICT_SRC_DIR
cd $DICT_SRC_DIR
pwd
make 
if [ $? -ne 0 ]; then
  echo "Making dictionary aborted."
  exit -1
fi
sudo ./install.sh
