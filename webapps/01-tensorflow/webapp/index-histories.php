<tr>
  <th>Image</th>
  <th>Predicted label / Timestamp</th>
</tr>
<?php
$uploaddir = dirname($_SERVER['SCRIPT_FILENAME']).'/histories';
foreach (scandir($uploaddir,SCANDIR_SORT_DESCENDING) as $file):
  if(!preg_match("/.+\.jpg/",$file)) continue;
  $resultfile = $uploaddir.'/'.str_replace(".jpg",".json",$file);
  if(is_file($resultfile)){
    $json = json_decode(file_get_contents($resultfile),true);
    $predicted_label = $json["predicted_label"];
    $ip = $json["uploaded_from"];
  }else{
    $predicted_label = "";
    $ip = str_replace(".jpg",".json",$file)." not found";
  }
?>
<tr>
  <td><img class="img img-responsive" src="histories/<?php echo $file; ?>" alt="<?php echo $file; ?>" style="max-width: 64px"/></td>
  <td><?php echo $predicted_label; ?><br/>
    <span class="text-muted"><?php echo date("Y-m-d H:i:s", filemtime($uploaddir.'/'.$file))." ".$ip; ?></span>
  </td>
</tr>
<?php endforeach; ?>
