#!/usr/bin/php
<?php
$htmlfile = "index.html";
$str = file_get_contents('http://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1');
$array = json_decode($str);
$imgurl = $array->{"images"}[0]->{"url"};
$content = file_get_contents($imgurl);
$imgname = basename($imgurl);
file_put_contents($imgname, $content);
file_put_contents($htmlfile, "<img src=$imgname>\n".file_get_contents($htmlfile));
?>
