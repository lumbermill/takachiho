<?php
include "./common.php";
  $analyze_script = "$script_dir/hyoki_yure.py";
  $input_text = $_REQUEST["input"];
  $input_text = mb_convert_kana($input_text, "ASKV");
  system("echo '$input_text' | $python $analyze_script");

