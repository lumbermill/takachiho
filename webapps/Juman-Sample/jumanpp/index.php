<?php
  $title="JUMAN++表記ゆれ検出サンプル";
  include "./header.php";
?>
    <div class="container">
      <h1><?= $title ?></h1>
      <textarea id="input" cols=100 rows=20></textarea>
      <button id="analyze">検出</button> 
      <div id="result"></div>
    </div>
    <script type="text/javascript">
      (function(){
        $('#analyze').on('click', function(){
           $.ajax({
             type: "POST",
             url:      './analyze.php',
             data:     { 'input': $('#input').val() },
             dataType: 'html',
             success: function(response){
               $('#result').html(response);
             },
             error: function(response) {
               alert(response);
             }
          });
        });
      })();
  </script>
  </body>
</html>