<?php
  $python = "/usr/bin/python";
  $analyze_script = "/home/ubuntu/src/takachiho/webapps/Juman-Sample/hyoki_yure.py";
  $input_text = $_REQUEST["input"];
  echo system("echo $input_text | $python $python");

