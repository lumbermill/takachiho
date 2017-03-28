
<!DOCTYPE html>
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
      <h1>Tensorflow</h1>
      <div class="row">
        <div class="col-sm-6">
          <h3>Eval</h3>
          <form class="form-inline">
            <input type="file" name="file" class="form-control"/>
            <button class="btn btn-primary">Upload</button>
          </form>
          <h3>Setting</h3>
          <ul>
            <li>Model: mnist</li>
            <li>Labels: 0 1 2 3 4 5 6 7 8 9</li>
            <li>Version of Tensorflow: <strong id="version-of-tensorflow"></strong></li>
          </ul>
          <h4>How to change models</h4>
          <pre>brah brah..
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
    </div><!-- /.container -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <script>
      $("#version-of-tensorflow").load("index-cmd.php",{"cmd": "version"});
      $("#histories").load("index-histories.php");
    </script>
  </body>
</html>
