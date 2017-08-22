<?php
require_once './common.php';
?><!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="favicon.ico">

    <title>Tensorflow demo</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
  </head>

  <body>
    <div class="container">
      <h1>Tensorflow <small><a href="<?php echo $_SERVER["SCRIPT_NAME"] ?>" class="text-muted"><span class="glyphicon glyphicon-refresh"></span></a></small></h1>
      <div class="row">
        <div class="col-sm-6">
          <h3>Eval</h3>
          <form class="form-inline" method="post" enctype="multipart/form-data" action="index_do.php">
            <input type="file" name="file" class="form-control"/>
            <span class="text-muted">.jpg</span>
            <button class="btn btn-primary">Upload</button>
          </form>
          <h3>Setting</h3>
          <ul>
            <li>Model: <?php echo $modelsdir."/".$model_name; ?></li>
            <li>Labels: <?php echo implode(" ",$model_labels); ?></li>
            <li>Version of Tensorflow: <strong id="version-of-tensorflow"></strong></li>
            <li>Version of OpenCV: <strong id="version-of-opencv"></strong></li>
            <li>Histories: <?php echo $uploaddir ?></li>
          </ul>
          <h4>How to change models</h4>
          <pre>1. Place your model.ckpt and other files into model directory.<br/>
            2. Edit <i>common.php</i> to switch the model and labels.
          </pre>
        </div>
        <div class="col-sm-6">
          <h3>Histories</h3>
          <table class="table table-striped" id="histories">
          </table>
          <p class="muted">
            <a href="histories/">See more histories..</a>
          </p>
        </div>
      </div>
      <footer>
        <a href="https://github.com/lumbermill/takachiho/tree/master/webapps/01-tensorflow">GitHub</a>
      </footer>
    </div><!-- /.container -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <script>
      $("#version-of-tensorflow").load("index-cmd.php",{"cmd": "version","module": "tensorflow"});
      $("#version-of-opencv").load("index-cmd.php",{"cmd": "version","module": "cv2"});
      $("#histories").load("index-histories.php");
    </script>
  </body>
</html>
