VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsMenuItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'�˵����࣬��ʾÿһ���˵���

Private m_dicTotal As Dictionary                                                '����ȫ�������ԣ�����Ĭ��ֵ
Private m_Base As clsBaseControl                                                '�����ؼ���
Private m_Visible As Boolean
Private m_IsSeparator As Boolean
Private m_IsCheckBox As Boolean

Private m_Childs() As Object
Private m_numChilds As Long
Private m_IdxCurChild As Long

'���PYTHON����,
'sCmdFunc: ����������¼������ص�����;
'rel:�Ƿ�ʹ���������,
'oop:�Ƿ�ʹ�����������
'usettk:�Ƿ�ʹ��TTK������չ
Public Function toString(ByRef sCmd As cStrBuilder, rel As Boolean, oop As Boolean, usettk As Boolean) As String
    
    Dim sOut As New cStrBuilder
    
    If oop Then
        toStringOOP sOut, sCmd, rel
    Else
        toStringStructure sOut, sCmd, rel
    End If
    
    toString = sOut.toString(vbCrLf)
    
End Function

'����ṹ������
Public Sub toStringStructure(ByRef sOut As cStrBuilder, ByRef sCmd As cStrBuilder, rel As Boolean)
    
    Dim i As Long, extra As String, var As String, sTmp As String, s() As String
    
    extra = IIf(m_Base("tearoff") <> "", ", tearoff=" & m_Base("tearoff"), "")
    
    If m_numChilds > 0 Then
        sOut.Append vbCrLf & Space(4) & m_Base.Name & " = Menu(" & m_Base.Parent & extra & ")"
        For i = 0 To m_numChilds - 1                                            '�ݹ����ɴ���
            m_Childs(i).toStringStructure sOut, sCmd, rel
        Next
        
        sOut.Append Space(4) & "gComps['" & m_Base.Name & "'] = " & m_Base.Name
        If m_Visible Then                                                       '���Visible=0��һ��˵���˲˵�����Ϊ�Ҽ������˵�
            m_Base("variable") = ""
            m_Base("command") = ""
            extra = GetExtraParams(False)
            sOut.Append Space(4) & m_Base.Parent & ".add_cascade(menu=" & m_Base.Name & IIf(Len(extra), ", " & extra, "") & ")"
        End If
    ElseIf m_IsSeparator Then                                                   '�˵��ָ���
        sOut.Append Space(4) & m_Base.Parent & ".add_separator()"
    ElseIf m_IsCheckBox Then                                                    ' �˵�����ѡ���
        If m_Base("variable") <> "" Then
            sOut.Append Space(4) & m_Base("variable") & " = StringVar()"
            sOut.Append Space(4) & m_Base("variable") & ".set(1)"
        End If
        If m_Base("command") = "" Then m_Base("command") = m_Base.Name & "_Cmd"
        extra = GetExtraParams(False)
        sOut.Append Space(4) & m_Base.Parent & ".add_checkbutton(" & extra & ")"
        sCmd.Append m_Base.CreateFuncDef(m_Base("command"), "event=None")
    Else                                                                        '�Ӳ˵�
        var = m_Base("variable")
        m_Base("variable") = ""
        If m_Base("command") = "" Then m_Base("command") = m_Base.Name & "_Cmd"
        extra = GetExtraParams(False)
        m_Base("variable") = var
        sOut.Append Space(4) & m_Base.Parent & ".add_command(" & extra & ")"
        sCmd.Append m_Base.CreateFuncDef(m_Base("command"), "event=None")
    End If
    
    '����Ҫʹ��bind���󶨵������¼�����
    If m_numChilds = 0 And Not m_IsSeparator And Len(m_Base("bindcommand")) Then
        sTmp = UnQuote(m_Base("bindcommand")) '�Զ�ȥ�����ţ�����еĻ�
        
        s = Split(sTmp, ",")
        For i = 0 To UBound(s)
            s(i) = Trim(s(i))
            If Left(s(i), 1) = "<" And Right(s(i), 1) = ">" Then
                sOut.Append Space(4) & "top.bind_all('" & s(i) & "', " & m_Base("command") & ")"
                
                'Python�Ǵ�Сд���еģ���Ӧ��ݼ�Ҳһ����������õĿ�ݼ�������ĸ�����򽫶�Ӧ�Ĵ�д/СдҲһ���
                If Right(s(i), 2) >= "a>" And Right(s(i), 2) <= "z>" Then
                    s(i) = Left(s(i), Len(s(i)) - 2) & UCase(Mid(s(i), Len(s(i)) - 1, 1)) & ">"
                    sOut.Append Space(4) & "top.bind_all('" & s(i) & "', " & m_Base("command") & ")"
                ElseIf Right(s(i), 2) >= "A>" And Right(s(i), 2) <= "Z>" Then
                    s(i) = Left(s(i), Len(s(i)) - 2) & LCase(Mid(s(i), Len(s(i)) - 1, 1)) & ">"
                    sOut.Append Space(4) & "top.bind_all('" & s(i) & "', " & m_Base("command") & ")"
                End If
            End If
        Next
    End If
    
End Sub

'�������������
Public Sub toStringOOP(ByRef sOut As cStrBuilder, ByRef sCmd As cStrBuilder, rel As Boolean)
    
    Dim i As Long, extra As String, var As String, sTmp As String, s() As String
    
    extra = IIf(m_Base("tearoff") <> "", ", tearoff=" & m_Base("tearoff"), "")
    
    If m_numChilds > 0 Then
        sOut.Append vbCrLf & Space(8) & "self." & m_Base.Name & " = Menu(self." & m_Base.Parent & extra & ")"
        For i = 0 To m_numChilds - 1                                            '�ݹ����ɴ���
            m_Childs(i).toStringOOP sOut, sCmd, rel
        Next
        
        If m_Visible Then                                                       '���Visible=0��һ��˵���˲˵�����Ϊ�Ҽ������˵�
            m_Base("variable") = ""
            m_Base("command") = ""
            extra = GetExtraParams(True)
            sOut.Append Space(8) & "self." & m_Base.Parent & ".add_cascade(menu=" & "self." & m_Base.Name & IIf(Len(extra), ", " & extra, "") & ")"
        End If
    ElseIf m_IsSeparator Then                                                   '�˵��ָ���
        sOut.Append Space(8) & "self." & m_Base.Parent & ".add_separator()"
    ElseIf m_IsCheckBox Then                                                    ' �˵�����ѡ���
        If m_Base("variable") <> "" Then
            sOut.Append Space(8) & "self." & m_Base("variable") & " = StringVar()"
            sOut.Append Space(8) & "self." & m_Base("variable") & ".set(1)"
        End If
        
        If m_Base("command") = "" Then m_Base("command") = m_Base.Name & "_Cmd"
        extra = GetExtraParams(True)
        sOut.Append Space(8) & "self." & m_Base.Parent & ".add_checkbutton(" & extra & ")"
        sCmd.Append m_Base.CreateFuncDefOOP(m_Base("command"), "event=None")
    Else
        var = m_Base("variable")
        m_Base("variable") = ""
        If m_Base("command") = "" Then m_Base("command") = m_Base.Name & "_Cmd"
        extra = GetExtraParams(True)
        m_Base("variable") = var
        sOut.Append Space(8) & "self." & m_Base.Parent & ".add_command(" & extra & ")"
        sCmd.Append m_Base.CreateFuncDefOOP(m_Base("command"), "event=None")
    End If
    
    '����Ҫʹ��bind���󶨵������¼�����
    If m_numChilds = 0 And Not m_IsSeparator And Len(m_Base("bindcommand")) Then
        sTmp = UnQuote(m_Base("bindcommand")) '�Զ�ȥ�����ţ�����еĻ�
        
        s = Split(sTmp, ",")
        For i = 0 To UBound(s)
            s(i) = Trim(s(i))
            If Left(s(i), 1) = "<" And Right(s(i), 1) = ">" Then
                sOut.Append Space(8) & "self.top.bind_all('" & s(i) & "', " & "self." & m_Base("command") & ")"
                
                'Python�Ǵ�Сд���еģ���Ӧ��ݼ�Ҳһ����������õĿ�ݼ�������ĸ�����򽫶�Ӧ�Ĵ�д/СдҲһ���
                If Right(s(i), 2) >= "a>" And Right(s(i), 2) <= "z>" Then
                    s(i) = Left(s(i), Len(s(i)) - 2) & UCase(Mid(s(i), Len(s(i)) - 1, 1)) & ">"
                    sOut.Append Space(8) & "self.top.bind_all('" & s(i) & "', " & "self." & m_Base("command") & ")"
                ElseIf Right(s(i), 2) >= "A>" And Right(s(i), 2) <= "Z>" Then
                    s(i) = Left(s(i), Len(s(i)) - 2) & LCase(Mid(s(i), Len(s(i)) - 1, 1)) & ">"
                    sOut.Append Space(8) & "self.top.bind_all('" & s(i) & "', " & "self." & m_Base("command") & ")"
                End If
            End If
        Next
    End If
    
End Sub

'���������Ҫ���ϵ������������ʼ��������
Public Sub InitConfig(o As Object, Optional parentWidth As Long, Optional parentHeight As Long)
    
    Dim s As String
    
    m_Base.Name = o.Properties("Name")
    
    m_Visible = o.Properties("Visible")
    m_IsSeparator = (o.Properties("Caption") = "-")
    m_IsCheckBox = (o.Properties("Checked") = True)
    
    '��Щ�����е�Ĭ��ֵ
    m_dicTotal("label") = Replace(o.Properties("Caption"), "&", "")
    m_dicTotal("fg") = ""
    m_dicTotal("bg") = ""
    m_dicTotal("bd") = ""
    m_dicTotal("tearoff") = "0"
    m_dicTotal("relief") = "RAISED"
    m_dicTotal("state") = IIf(o.Properties("Enabled"), "'normal'", "'disabled'")
    m_dicTotal("underline") = IIf(InStr(1, o.Properties("Caption"), "&"), InStr(1, o.Properties("Caption"), "&") - 1, "-1")
    m_dicTotal("variable") = o.Properties("Name") & "Var"
    m_dicTotal("font") = ""
    m_dicTotal("accelerator") = TransShortcut(o.Properties("Shortcut"))
    m_dicTotal("command") = o.Properties("Name") & "_Cmd"
    m_dicTotal("postcommand") = ""
    m_dicTotal("bindcommand") = ""
    
    m_Base("tearoff") = m_dicTotal("tearoff")
    m_Base("variable") = m_dicTotal("variable")
    m_Base("command") = m_dicTotal("command")
    m_Base("label") = m_dicTotal("label")
    If m_dicTotal("state") <> "'normal'" Then m_Base("state") = m_dicTotal("state")
    If m_dicTotal("underline") <> "-1" Then m_Base("underline") = m_dicTotal("underline")
    
    If m_dicTotal("accelerator") <> "" Then                                     '��ݼ���
        s = m_dicTotal("accelerator")
        m_Base("accelerator") = s
        s = "'<" & Replace(s, "Ctrl", "Control") & ">'"
        m_Base("bindcommand") = s
    End If
    
End Sub

'��VB��ݼ���ö��ֵת��Ϊһ���ɶ����ַ���
Private Function TransShortcut(nsc As Long) As String
    Select Case nsc
    Case 0
        TransShortcut = ""
    Case vbextMenuShortcutCtrlA To vbextMenuShortcutCtrlZ                       '1 - 26
        TransShortcut = "Ctrl-" & Chr(nsc + 64)
    Case vbextMenuShortcutF1 To vbextMenuShortcutF12                            ' 27 - 38
        TransShortcut = "F" & CStr(nsc - 26)
    Case vbextMenuShortcutCtrlF1 To vbextMenuShortcutCtrlF12                    ' 39 - 50
        TransShortcut = "Ctrl-F" & CStr(nsc - 38)
    Case vbextMenuShortcutShiftF1 To vbextMenuShortcutShiftF12                  ' 51 - 62
        TransShortcut = "Shift-F" & CStr(nsc - 50)
    Case vbextMenuShortcutCtrlShiftF1 To vbextMenuShortcutCtrlShiftF12          '  63 - 74
        TransShortcut = "Ctrl-Shift-F" & CStr(nsc - 62)
    Case vbextMenuShortcutCtrlIns                                               '= 75
        TransShortcut = "Ctrl-Insert"
    Case vbextMenuShortcutShiftIns                                              '= 76
        TransShortcut = "Shift-Insert"
    Case vbextMenuShortcutDel                                                   '= 77
        TransShortcut = "Delete"
    Case vbextMenuShortcutShiftDel                                              ' = 78
        TransShortcut = "Shift-Delete"
    Case vbextMenuShortcutAltBksp                                               ' = 79
        TransShortcut = "Alt-BackSpace"
    Case Else
        TransShortcut = ""
    End Select
    
End Function


'���˱�ѡ�����⣬������������û�ѡ������������б�
Public Function GetExtraParams(Optional oop As Boolean = False) As String
    
    Dim cfg As Variant, k As Variant, ks As Variant, sValue As String
    
    Set ks = m_Base.Keys
    
    For Each k In ks
        If isExtra(k) And Len(m_Base(k)) Then
            '��Ҫʹ�����������������ԣ�����û����ˣ����������Զ�����
            sValue = m_Base(k)
            If InStr(1, " fg, bg, label, state, accelerator, ", " " & k & ",") Then
                If (Left(m_Base(k), 1) <> "'" And Left(m_Base(k), 1) <> Chr(34)) And (Right(m_Base(k), 1) <> "" And Right(m_Base(k), 1) <> Chr(34)) Then
                    sValue = "'" & m_Base(k) & "'"
                End If
            End If
            GetExtraParams = GetExtraParams & IIf(Len(GetExtraParams), ", ", "") & k & "=" & sValue
        End If
    Next
    
    If Len(m_Base("command")) Then
        GetExtraParams = GetExtraParams & IIf(Len(GetExtraParams), ", ", "") & "command=" & IIf(oop, "self.", "") & m_Base("command")
    End If
    If Len(m_Base("variable")) Then
        GetExtraParams = GetExtraParams & IIf(Len(GetExtraParams), ", ", "") & "variable=" & IIf(oop, "self.", "") & m_Base("variable")
    End If
    If Len(m_Base("font")) Then
        GetExtraParams = GetExtraParams & IIf(Len(GetExtraParams), ", ", "") & "font=" & IIf(oop, "self.", "") & m_Base.Name & "Font"
    End If
    
End Function

Private Function isExtra(ByVal sK As String) As Boolean
    isExtra = (InStr(1, " tearoff, variable, command, postcommand, bindcommand, font, ", Space(1) & sK & ",") <= 0)
End Function

'��������ֵ�Ŀ���ֵ�б�
'����ֵ��0-û�п�ѡֵ��1-��һ���ϸ����ƵĿ�ѡֵ�б���2-���ṩ�Ŀ�ѡֵ�б��⣬�������ֶ���������ֵ
'�����sa()��ѡֵ�б�����
Public Function GetAttrValueList(sAttr As String, ByRef sa() As String) As Long
    If sAttr = "tearoff" Then
        GetAttrValueList = 1
        sa = Split("1,0", ",")
    Else
        GetAttrValueList = m_Base.GetAttrValueList(sAttr, sa)
    End If
End Function

Public Function Tips(sAttr As String) As String
    
    If sAttr = "tearoff" Then
        Tips = sAttr & vbCrLf & L("l_TipTearOff", "�˵��Ƿ���Ա�ɵ������ڣ�����Ϊ1��Ĭ�ϣ�ʱ���˵���һ��Ϊ���ߣ��û�����������߻Ὣ�˵�����Ϊһ�������Ĵ��ڣ�����PYTHONĬ�ϱ༭��IDLEһ����")
    ElseIf sAttr = "postcommand" Then
        Tips = sAttr & vbCrLf & L("l_TipPostCmdMenu", "ÿ���û�����˵�����ʱ���õĻص�������")
    ElseIf sAttr = "accelerator" Then
        Tips = sAttr & vbCrLf & L("l_TipAcceleratorMenu", "ȫ�ֿ�ݼ����塣")
    Else
        Tips = m_Base.Tips(sAttr)
    End If
    
End Function

Private Sub Class_Initialize()
    
    Set m_dicTotal = New Dictionary
    Set m_Base = New clsBaseControl
    m_Base.ctlType = "Menu"
    m_Base.StyleName = ""
    m_Base.Parent = "MainMenu"
    Erase m_Childs
    m_numChilds = 0
    m_IdxCurChild = 0
    
End Sub

'����һ�����ϣ�ÿ����Ŀ��Ԫ��"������|ֵ|�Ƿ�Ĭ��ѡ��"
'�����������������������Բ����б���
Public Function Allitems() As Collection
    Dim re As Collection, k As Variant, ks As Collection
    
    Set re = New Collection
    
    '��׼����
    Set ks = m_dicTotal.Keys
    For Each k In ks
        If Len(m_Base(k)) Then
            re.Add k & "|" & m_Base(k) & "|1"
        Else
            re.Add k & "|" & m_dicTotal(k) & "|0"
        End If
    Next
    
    '�û����ӵ��Զ������������еĻ���
    Set ks = m_Base.Keys
    For Each k In ks
        If Not m_dicTotal.Exists(k) Then
            re.Add k & "|" & m_Base(k) & "|1"
        End If
    Next
    
    Set Allitems = re
    
End Function

Public Sub SetConfig(sAttrs As String)
    m_Base.SetConfig sAttrs
End Sub

Public Sub SetSingleConfig(sAttr As String)
    m_Base.SetSingleConfig sAttr
End Sub

Private Sub Class_Terminate()
    Set m_dicTotal = Nothing
    Set m_Base = Nothing
End Sub

Public Property Let Parent(s As String)
    m_Base.Parent = s
End Property

Public Property Get Parent() As String
    Parent = m_Base.Parent
End Property

Public Property Get Name() As String
    Name = m_Base.Name
End Property

Public Property Let Name(s As String)
    m_Base.Name = s
End Property

'�������л�����
Public Function Serializer(vSer As clsSerialization)
    vSer.Serializer m_Base
End Function

Public Function Deserializer(vSer As clsSerialization)
    vSer.Deserializer m_Base
End Function

Public Property Get Description() As String
    Description = L("l_DescMenuItem", "�˵������ÿһ�������Ӧ��Tkinter��Menu��Ӧ�������Ŀ��")
End Property

Public Sub AddChild(o As Object)
    ReDim Preserve m_Childs(m_numChilds) As Object
    Set m_Childs(m_numChilds) = o
    m_numChilds = m_numChilds + 1
End Sub

Public Function GetNextChild(Optional nIdxChild As Long = -1) As Object
    m_IdxCurChild = IIf(nIdxChild >= 0, nIdxChild, m_IdxCurChild)
    If m_IdxCurChild < m_numChilds Then
        Set GetNextChild = m_Childs(m_IdxCurChild)
        m_IdxCurChild = m_IdxCurChild + 1
    Else
        Set GetNextChild = Nothing
        m_IdxCurChild = 0
    End If
End Function

Public Property Get ChildCount() As Long
    ChildCount = m_numChilds
End Property

Public Property Let ScaleMode(nV As Long)
    m_Base.ScaleMode = nV
End Property
