<?php //php -S 0:8000 list.php
$uri = trim($_SERVER['REQUEST_URI'],'/');
$dir = $_SERVER['DOCUMENT_ROOT'].'/'.$uri;
if (is_file($dir)) return false;
echo "<meta charset=utf8>Index of $dir<form align=right method=post enctype=multipart/form-data><input name=f type=file /><input type=submit /></form><hr><pre>";
if ($_FILES) move_uploaded_file($_FILES['f']['tmp_name'],$dir.'/'.$_FILES['f']['name']); 
foreach (scandir($dir) as $v) echo "<a href=\"/./$uri/$v\">$v".(is_dir("$dir.'/'.$v")?'/':'')."</a>\n";
return true;
