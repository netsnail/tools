<?php
$title='server list';
$host='127.0.1';
ser='root';
$pass='xxxxxx';
$dbname='test';
$table='server_copy1';
$sql="select * from $table";
$del="delete from $table where ip=";
$rows_per_page=30;
if($_SERVER['HTTP_AUTHORIZATION']!='Basic xxxxxx')exit(header('WWW-Authenticate: Basic'));
?>
<!DOCTYPE html><html><head><title><?php echo$title;?></title><meta charset=utf-8>
<style>*{margin:0;font-size:0.8em;}body{margin:5px;}table,th,td{border-collapse:collapse;border:1px solid black;padding:2px 5px;}
table{width:100%;margin:5px 0 20px;}tr:hover{background:lightyellow;}td{max-width:500px;overflow-wrap:break-word;}
nav{white-space:pre-wrap;position:fixed;left:0;bottom:0;background:#c99;padding:0px 5px;border-radius:3px;}
</style></head><body>
<?php $conn=mysqli_connect($host,$user,$pass,$dbname);if(!$conn)log("connect failed");
if($_POST['del']){
  foreach($_POST['del'] as $d){mysqli_query($conn,$del."'".$d."'");}
  header("Location: ".$_SERVER['REQUEST_URI']);
}

if(!isset($_GET['pg'])){$pg=0;}else{$pg=$_GET['pg'];}
$start=$pg*$rows_per_page;
$colv=$_GET['colv'];$coln=$_GET['coln'];$cond=$_GET['cond'];
if($colv!=''){$sql.=" where ".$coln." ".$cond."'".$colv."'";}
$result=mysqli_query($conn,$sql);
$total_records=mysqli_num_rows($result);
$pages=ceil($total_records/$rows_per_page);
mysqli_free_result($result);
$sql.=" LIMIT $start,$rows_per_page";
log("$sql");$page=mysqli_query($conn,$sql);
if(!$page)log("result set cannot given out");
$cols=[];while($row=mysqli_fetch_field($page))array_push($cols,$row->name);
$symbol=['=','>','>=','<','<=','like'];

echo'<form name=form method=post><input type=hidden name=coln value='.$coln.'><input type=hidden name=colv value='.$colv.'>
<input type=hidden name=cond value='.$cond.'><input type=hidden name=pg value='.$pg.'>
<select style=margin-left:10px; name=coln>';foreach($cols as $v){echo"<option";if($coln==$v)echo" selected";echo">$v</option>";}echo'</select>&nbsp;
<select name=cond>';foreach($symbol as $v){echo"<option";if($cond==$v)echo" selected";echo">$v</option>";}echo'</select>&nbsp;
<input name=colv value='.$colv.'>&nbsp;<button onclick=\'form.method="get";form.submit()\'>Search</button>
<button style=float:left; onclick=\'return confirm("Delete ?")&&form.submit()\'>Delete</button>
<table><caption></caption><colgroup><col style=background:#def;></colgroup>
<th><input onclick="form.dels.forEach(v=>v.checked=!v.checked)" type=checkbox></th>';
foreach($cols as $v){echo"<th>".strtoupper($v)."</th>";}
while($row=mysqli_fetch_array($page,MYSQLI_NUM)){
  echo"<tr><td><input id=dels name=del[] value=".$row[0]." type=checkbox>";
  foreach($row as $v){echo"</td><td>".(strlen($v)<50?"<span>$v</span>":"<span onclick='this.innerText=this.attributes.data.value' data='$v'>".substr($v,0,50)."...</span>");}
  echo"</td><tr>";
}echo"</table></form>";

echo"<nav>";$url.="?1=1";if($coln)$url.="&coln=$coln";if($cond)$url.="&cond=$cond";if($colv)$url.="&colv=$colv";
if($pg>0){echo" <a href=\"$url&pg=0\">&lt;&lt</a> ";echo" <a href=\"$url&pg=".($pg-1)."\">&lt;</a> ";}
$links=0;$left=($pg+1-4);$right=($pg+1+4);
if($pg<=3){$left=1;$right=9;}elseif($pg>$pages-5){$right=$pages;$left=$pages-8;}
for($i=$left;$i<=$right;$i++){
  if($i==$pg+1){echo" <b><a href=\"$url&pg=".($i-1)."\">$i</a></b> ";}else{echo" <a href=\"$url&pg=".($i-1)."\">$i</a> ";}
}
if($pg<$pages-1){echo" <a href=\"$url&pg=".($pg+1)."\">&gt;</a> ";echo" <a href=\"$url&pg=".($pages-1)."\">&gt;&gt;</a> ";}
echo"      pages: $pages, records: $total_records</nav>";
?>
