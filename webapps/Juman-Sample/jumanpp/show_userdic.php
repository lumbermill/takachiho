<?php
  $title="JUMAN++ユーザー辞書";
  include "./header.php";
  include "./common.php";
  $row_of_page = 20;
  $page = isset($_REQUEST['p']) ?  $_REQUEST['p'] : 1;
  $start = ($page - 1) * $row_of_page + 1;
  $end   = $start + $row_of_page - 1;
?>
<div class="container">
  <h1><?= $title ?></h1>
  <p>独自に追加した語彙の一覧です。</p>
  <a href="./index.php">表記ゆれ検出に戻る</a>
  <a href="./show_userdic.php?p=<?= $page - 1 ?>">前のページ</a>
  <a href="./show_userdic.php?p=<?= $page + 1?>">次のページ</a>
  <div id="userdict">
    <pre><?php
      $midasi_script = "$script_dir/midasi.rb";
      exec("cat $userdic_dir/* | sort -u | sed -n '${start},${end}p'| $ruby $midasi_script",$output);
      foreach ($output as $out) {
        printf("\n%s:\n", $out);
        $word = explode(":", $out);
        $output2 = null;
        exec("echo $word[0] | $jumanpp | grep -v EOS",$output2);
        foreach ($output2 as $answer){
          printf("\t%s\n", $answer);
        }
      }
    ?></pre>
  </div>
</div>
<?php include "./footer.php"; ?>

