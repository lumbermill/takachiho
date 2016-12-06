<?php
  $title="JUMAN++辞書アップロード";
  include "./header.php";
?>
<div class="container">
  <h1><?= $title ?></h1>
  <form id="upload" method="post" enctype="multipart/form-data">
    <input type="file" name="dict_file" />
  </form>
  <button id="up_dict">アップロード</button>
  <div id="result">
    <pre></pre>
  </div>
</div>
<script type="text/javascript">
(function(){
  $('#up_dict').on('click', function(){
    var formdata = new FormData($('#upload').get(0));
    $.ajax({
      type: "POST",
      url: './do_dict_upload.php',
      data: formdata,
      cache       : false,
      contentType : false,
      processData : false,
      dataType: 'html',
      success: function(response){
        $('#result pre').html(response);
      },
      error: function(response) {
        alert(response);
      }
    });
  });
})();
</script>
<?php include "./footer.php"; ?>

