<?php
// $model_name = "cifar";
// $model_labels = array("airplane","automobile","bird","cat","deer","dog","frog","horse","ship","truck");
// $model_name = "cucumber";
// $model_labels = array("2L","L","M","S","2S","BL","BM","BS","C");
$model_name = "mnist";
$model_labels = array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
$uploaddir = dirname($_SERVER['SCRIPT_FILENAME']).'/histories';
$modelsdir = dirname($_SERVER['SCRIPT_FILENAME']).'/models';
