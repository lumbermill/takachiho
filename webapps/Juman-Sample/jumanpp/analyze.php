<?php
  $python = "/usr/bin/python";
  $analyze_script = "/home/ubuntu/src/takachiho/webapps/Juman-Sample/hyoki_yure.py";
  $input_text = $_REQUEST["input"];
  $input_text = mb_convert_kana($input_text, "ASKV");
  system("echo '$input_text' | $python $analyze_script");

