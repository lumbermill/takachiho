<?php
require_once './common.php';
if (isset($_FILES['file'])){
  $ts = date("ymd_His");
  $uploadfile = $uploaddir .'/'. $ts . ".jpg";

  if (!move_uploaded_file($_FILES['file']['tmp_name'], $uploadfile)) {
    echo "Possible file upload attack!\n";
    exit;
  }
  $started_at = microtime(true);
  $predicted = system("python3 predict2.py --image $uploadfile --model $modelsdir/$model_name/model.ckpt");
  $elapsed = round(microtime(true) - $started_at,3);
  $resultfile = $uploaddir . '/' . $ts . ".json";
  $json = array();
  $json["predicted_label"] = $predicted;
  $json["correct_label"] = ""; // Always empty here.
  $json["model_name"] = "";
  $json["uploaded_from"] = $_SERVER['REMOTE_ADDR'];
  $json["elapsed"] = $elapsed;
  file_put_contents($resultfile, json_encode($json));
}
header("Location: index.php");
