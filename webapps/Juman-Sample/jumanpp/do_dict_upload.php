<?php
$home_dir= "/home/ubuntu";
$input_file = $_FILES["dict_file"]["tmp_name"];
$userdic_dir    = "$home_dir/src_juman/jumanpp-1.01/dict-build/userdic";

$ruby = "/usr/bin/ruby -Ku";
$parser_script = "$home_dir/src/takachiho/webapps/Juman-Sample/parse.rb";

$bash = "/bin/bash";
$build_script = "$home_dir/src/takachiho/webapps/Juman-Sample/dict_build.sh";

// 文法チェック
$return_var = 0;
system("cat $input_file | $ruby $parser_script", $return_var);
var_dump($return_var);
// 文法チェックOKならdict-build/userdicディレクトリに適当な名前で保存
if ($return_var == 0) {
  $filename = date('Ymd_His', time()); 
  copy($input_file, "$userdic_dir/$filename.dic");
  // make & install
  //system("$bash $build_script");
} else {
  echo "ファイル形式に誤りがあります。";
} 


