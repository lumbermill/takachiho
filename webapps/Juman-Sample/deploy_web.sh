#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0);pwd)
JUMAN_WEB_DIR=/var/www/html/jumanpp/
sudo rsync -av $SCRIPT_DIR/jumanpp/ $JUMAN_WEB_DIR
