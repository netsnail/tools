<?php header("Content-Type: text/html; charset=UTF-8"); ?>
<style>
h1 { text-align:center; }
table,tr,th,td { border-collapse:collapse;border:1px solid gray; }
th { background:#ccc; }
div { margin-top:20px; text-align:center; }
</style>
<h1>FINDBUGS</h1>
<?php
$perpagenum = 20;

$conn = mysql_connect('192.168.1.242', 'root', 'root'); mysql_select_db('findbugs', $conn); mysql_query("set names utf8");
$total = mysql_fetch_array(mysql_query("select count(*) from bugs"));

$Total = $total[0]; $Totalpage = ceil($Total / $perpagenum);

if(!isset($_GET['page'])||!intval($_GET['page'])||$_GET['page']>$Totalpage) {    
    $page=1;
} else $page=$_GET['page'];

$startnum = ($page-1) * $perpagenum;
$sql = "select * from bugs order by id desc limit $startnum,$perpagenum";
$rs = mysql_query($sql); $content = mysql_fetch_array($rs);    
if ($total) {    
  echo "<table><tr><th>Project</th><th>User</th><th>Bug</th><th>Comment</th><th>Time</th></tr>\n";
  do {    
?>
  <tr>    
    <td><?php echo $content['project'];?></td>    
    <td><?php echo $content['user'];?></td>    
    <td style="white-space: pre-wrap;"><?php echo $content['bug'];?></td>    
    <td><?php echo $content['comment'];?></td>    
    <td><?php echo $content['create_time'];?></td>    
  </tr>
<?php    
  } while($content = mysql_fetch_array($rs));
  echo "</table>\n";

  $per = $page - 1;
  $next = $page + 1;
  echo "<div>共".$Total."条, 每页".$perpagenum."条, 共".$Totalpage."页 ";    
  if($page != 1) {
    echo "<a href='".$_SERVER['PHP_SELF']."'>首页</a> ";    
    echo "<a href='".$_SERVER['PHP_SELF'].'?page='.$per."'>上一页</a> ";    
  }    
  if($page != $Totalpage) {    
    echo "<a href='".$_SERVER['PHP_SELF'].'?page='.$next."'>下一页</a> ";    
    echo "<a href='".$_SERVER['PHP_SELF'].'?page='.$Totalpage."'>尾页</a>";    
  }
  echo "</div>";
}
?>
