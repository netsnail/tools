i=0
Dim con
con = MsgBox("开始工作吗？", vbYesNo + vbInformation, "番茄个数 "&i)

do while con = vbYes
  WScript.sleep 25*60*1000
  MsgBox "休息一下吧！", vbOkOnly, "番茄个数 "&i
  WScript.sleep 5*60*1000
  i=i+1
  if 0 = i mod 4 then
    WScript.sleep 20*60*1000
  end if
  con = MsgBox("继续工作吗？", vbYesNo + vbInformation, "番茄个数 "&i)
loop 
