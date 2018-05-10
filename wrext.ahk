;Win-R-EXT SystemAssisst Mode
;Win + R �ŋN������u�t�@�C�������w�肵�Ď��s�v���g��
;����ۂ̓��͑��Ɂu/�v����͂���Ɣ���

#IfWinActive �t�@�C�������w�肵�Ď��s

  ActivateMode()
  {
    Global pb1
    Global pb2
    Global pb3
    Global pb4
    Global pb5
    Global rlist
    Global pprev

    IniRead, fpath, wrext.ini, General, FirstPath, c: ;������ini�t�@�C���ɏ����f�B���N�g�����Z�b�g���Ă��������B
    IniRead, rlist, wrext.ini, General, ReplaceList, 
    WinMove, , , x, y, 900,
    ControlMove, ComboBox1, , , 800,
    SetPath(fpath)
    ControlMove, Static2, , , 800,
    ControlSetText, Static2, EXT [/]=���̊K�w [Ctrl+Backspace]=�O�̊K�w [Tab]=���̌�� [Ctrl+[1-5]]=�߽�ۑ� [Ctrl+Enter]=�߽����(1-5)`n[Ctrl + s]=�����Z�b�g [Ctrl + d]=�f�B���N�g���쐬 [Ctrl+q]=�߽�ؑ�, �t�@�C�������w�肵�Ď��s
    SendKey("{End}")
    SendKey("\")
  }

  InActiveMode()
  {
    ControlGetText, capt, Static2, �t�@�C�������w�肵�Ď��s
    return (RegExMatch(capt, "^EXT") == 0)
  }

  SetPath(file)
  {
    ControlSetText, ComboBox1, %file%, �t�@�C�������w�肵�Ď��s
  }

  GetPath(ByRef file)
  {
    ControlGetText, file, ComboBox1, �t�@�C�������w�肵�Ď��s
  }

  GetComboPos(ByRef x, ByRef y, ByRef w, ByRef h)
  {
    ControlGetPos, x, y, w, h, ComboBox1, �t�@�C�������w�肵�Ď��s
  }

  SendKey(key)
  {
    ControlSend, ComboBox1, %key%, �t�@�C�������w�肵�Ď��s
  }

  UpperPath(file)
  {
    ret := RegExReplace(file, "\\?[^\\]+[\\]?$", "")
    return ret
  }

  /::
    GetPath(file)
    if(InActiveMode())
    {
      Send, /
      GetPath(file)
      if file = /
      {
        ActivateMode()
      }
    }
    else
    {
      FileGetShortcut, %file%, OutTarget, OutDir, OutArgs, OutDesc, OutIcon, OutIconNum, OutRunState
      if OutTarget =
      {
        GetPath(file)
        if RegExMatch(file, "\\$") > 0
        {
          SendKey("{End}")
          SendKey("{Backspace}")
        }
        SendKey("\")
        GetPath(file)
        if file = \
        {
          ActivateMode()
        }
      }
      else
      {
        GetPath(pprev)
        SetPath(OutTarget)
        SendKey("{End}")
        text = Shortcutted from %pprev%
        ShowTip(text)
      }
    }
  return

  Tab::
    if(InActiveMode())
    {
      Send, {Tab}
      return
    }
    IfWinExist ahk_class Auto-Suggest Dropdown
    {
      SendKey("{Down}")
    }
    else
    {
      SendKey("{End}")
    }
  return

  +Tab::
    if(InActiveMode())
    {
      Send, +{Tab}
      return
    }
    IfWinExist ahk_class Auto-Suggest Dropdown
    {
      SendKey("{Up}")
    }
    else
    {
      SendKey("{End}")
    }
  return

  ^Backspace::
    if(InActiveMode())
    {
      Send, ^{Backspace}
      return
    }
    GetPath(file)
    filerep := UpperPath(file)
    SetPath(filerep)
    if filerep =
      return
    Send, {End}
    Send, \
  return

  ^Enter::
    if(InActiveMode())
      return
    GetPath(pprev)
    rpath = %pb1% %pb2% %pb3% %pb4% %pb5%
    SetPath(rpath)
    SendKey("{Home}")
    Send, +{End}
  return

  ^q::
    if(InActiveMode())
      return
    if rlist =
      return
    GetPath(pprev)
    GetPath(file)
    cnt = 0
    Loop
    {
      cnt += 1
      FileReadLine, line, %rlist%, %cnt%
      if ErrorLevel <> 0
        break
      p1 := RegExReplace(line, "^([^\=]*)\=(.*)$", "$1")
      p2 := RegExReplace(line, "^([^\=]*)\=(.*)$", "$2")
      if p1 =
        continue
      StringReplace, file, file, %p1%, %p2%, All
      if ErrorLevel = 0
      {
        text = Converted From %pprev%
        ShowTip(text)
        break
      }
    }
    SetPath(file)
    SendKey("{End}")
  return

  ^b::
    if pprev = 
      return
    sprev = %pprev%
    GetPath(pprev)
    SetPath(sprev)
    SendKey("{End}")
    text = Undo ..
    ShowTip(text)
  return

  ^1::
    SavePath(1, pb1)
  return
  ^+1::
    LoadPath(1, pb1)
  return
  
  ^2::
    SavePath(2, pb2)
  return
  ^+2::
    LoadPath(2, pb2)
  return

  ^3::
    SavePath(3, pb3)
  return
  ^+3::
    LoadPath(3, pb3)
  return

  ^4::
    SavePath(4, pb4)
  return
  ^+4::
    LoadPath(4, pb4)
  return

  ^5::
    SavePath(5, pb5)
  return
  ^+5::
    LoadPath(5, pb5)
  return

  ^d::
    GetPath(dir)
    FileCreateDir %dir%
    if ErrorLevel = 0
    {
      text = CreatedDir %dir%
      ShowTip(text)
    }
    else
    {
      ShowTip("Error...")
    }
  return

  ^s::
    dt:=A_Now
    Send, %dt%
  return

  SavePath(num, ByRef ppath)
  {
    if(InActiveMode())
      return
    GetPath(ppath)
    text = Saved to [%num%] %ppath%
    ShowTip(text)
  }

  LoadPath(num, ByRef ppath)
  {
    if(InActiveMode())
      return
    GetPath(pprev)
    SetPath(ppath)
    SendKey("{End}")
    text = Loaded from [%num%] %ppath%
    ShowTip(text)
  }

  ShowTip(text)
  {
    GetComboPos(x, y, w, h)
    yh := y + h
    ToolTip , %text%, %x%, %yh%
    SetTimer, RemoveToolTip, 3000
  }

  RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
  return
return