<?php
  $cmd = $_REQUEST['cmd'];
  if($cmd == "version") {
    system("python3 -c 'import tensorflow as tf; print(tf.__version__)'");
  } else {
    echo "Unknown command: ".$cmd;
  }
