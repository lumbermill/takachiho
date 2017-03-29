<?php
  $cmd = $_REQUEST['cmd'];
  if($cmd == "version") {
    $module = $_REQUEST['module'];
    if(!preg_match("/[a-z0-9]+/",$module)) {
      echo "Unknown module: ".$module;
      exit;
    }
    system("python3 -c 'import $module as m; print(m.__version__)'");
  } else {
    echo "Unknown command: ".$cmd;
  }
