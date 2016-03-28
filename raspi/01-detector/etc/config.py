# coding: UTF-8
import os
# フォルダのパス
FOLDER_PATH = os.environ["PROJECT_PATH"]+"/01-detector"
PICTURE_NAME = "%y%m%d_%H%M%S.jpg"

# 撮影間隔 high=センサー反応時 low=反応なし
INTERVAL_HIGH = 10
INTERVAL_LOW = 600
