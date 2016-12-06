<?php
include "./common.php";
$input_file    = $_FILES["dict_file"]["tmp_name"];
$parser_script = "$script_dir/parse.rb";
$build_script  = "$script_dir/dict_build.sh";

// 文法チェック
$return_var = 0;
system("cat $input_file | $ruby $parser_script", $return_var);
var_dump($return_var);
// 文法チェックOKならdict-build/userdicディレクトリに適当な名前で保存
if ($return_var != 0) {
  echo "ファイル形式に誤りがあります。";
  die;
} 

$filename = date('Ymd_His', time()); 
copy($input_file, "$userdic_dir/$filename.dic");

// make & install
system("$bash $build_script", $return_var);
if ($return_var != 0) {
  echo "辞書のビルドに失敗しました。";
  die;
} 
