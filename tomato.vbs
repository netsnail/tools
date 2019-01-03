i=1
Dim con
con = MsgBox("开始工作吗？", vbYesNo + vbInformation, "第 "&i&" 个番茄")

do while con = vbYes
  WScript.sleep 25*60*1000
  MsgBox "休息一下吧！", vbOkOnly, "第 "&i&" 个番茄"
  WScript.sleep 5*60*1000
  if 0 = i mod 4 then
    WScript.sleep 20*60*1000
  end if
  i=i+1
  con = MsgBox("继续工作吗？", vbYesNo + vbInformation, "第 "&i&" 个番茄")
loop 
