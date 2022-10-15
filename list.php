<?php //php -S 0:8000 list.php
$path = trim($_SERVER['REQUEST_URI'],'/');
$file = $_SERVER['DOCUMENT_ROOT'].'/'.$path;
if (is_file($file)) return false;
echo '<meta charset=utf8><pre><form method=post enctype=multipart/form-data><input name=f type=file /><input type=submit /></form>';
if ($_FILES) move_uploaded_file($_FILES['f']['tmp_name'],$file.'/'.$_FILES['f']['name']);
foreach (scandir($file) as $v) echo "<a href=/./$path/$v>$v".(is_dir($file.'/'.$v)?'/':'')."</a>\n";
return true;
