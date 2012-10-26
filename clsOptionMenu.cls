VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsOptionMenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'����ѡ��˵��࣬�������úͱ�����Ӧ�����Ժ�ֵ�������ɶ�ӦPYTHON��TKinter����

Private m_dicTotal As Dictionary                                                '����ȫ�������ԣ�����Ĭ��ֵ
Private m_Base As clsBaseControl                                                '�����ؼ���
Private m_List As String

'���PYTHON����,
'sCmdFunc: ����������¼������ص�����;
'rel:�Ƿ�ʹ���������,
'oop:�Ƿ�ʹ�����������
'usettk:�Ƿ�ʹ��TTK������չ(���ʹ��TTK����VB����Ͽ��Ӧ��TTK����Ͽ򣬲�����������ؼ�)
Public Function toString(ByRef sCmdFunc As cStrBuilder, rel As Boolean, oop As Boolean, usettk As Boolean) As String
    
    If Len(m_Base("variable")) = 0 Then
        MsgBox L_F("l_msgMusthasVar", "OptionMenu(ComboBox)����Ҫѡ��variable���ԣ����ڽ�������OptionMenu({0})�Ĵ��롣", m_Base.Name), vbInformation
        Exit Function
    End If
    
    If oop Then
        toString = toStringOOP(sCmdFunc, rel, usettk)
    Else
        toString = toStringStructure(sCmdFunc, rel, usettk)
    End If
    
End Function

'����ṹ������
Private Function toStringStructure(ByRef sCmdFunc As cStrBuilder, rel As Boolean, usettk As Boolean) As String
    
    Dim sOut As New cStrBuilder, s() As String, i As Long, extra As String
    
    sOut.Append Space(4) & m_Base.Name & "List = " & m_List
    sOut.Append Space(4) & m_Base("variable") & " = StringVar(value=" & m_Base.Name & "List[0])"
    
    extra = m_Base("variable") & ", *" & m_Base.Name & "List"
    
    sOut.Append Space(4) & m_Base.Name & " = OptionMenu(" & m_Base.Parent & IIf(Len(extra), ", ", "") & extra & ")"
    sOut.Append Space(4) & m_Base.Name & ".place(" & m_Base.GetPositionParams(rel) & ")"
    sOut.Append Space(4) & "gComps['" & m_Base.Name & "'] = " & m_Base.Name
    sOut.Append Space(4) & "gComps['" & m_Base("variable") & "'] = " & m_Base("variable")
    
    '�����¼�����������ܣ�����У�
    sCmdFunc.Append m_Base.CreateFuncDef(m_Base("command"))
    
    If Len(m_Base("bindcommand")) Then                                          '����Ҫʹ��bind���󶨵������¼�����
        s = Split(m_Base("bindcommand"), ",")
        For i = 0 To UBound(s)
            s(i) = Trim(s(i))
            If Left(s(i), 1) = "<" And Right(s(i), 1) = ">" Then
                sOut.Append Space(4) & m_Base.Name & ".bind('" & s(i) & "', " & m_Base.Name & "_" & Replace(Mid(s(i), 2, Len(s(i)) - 2), "-", "_") & ")"
                sCmdFunc.Append m_Base.CreateFuncDef(m_Base.Name & "_" & Replace(Mid(s(i), 2, Len(s(i)) - 2), "-", "_"), "event")
            End If
        Next
    End If
    
    toStringStructure = sOut.toString(vbCrLf)
    
End Function

'�������������
Private Function toStringOOP(ByRef sCmdFunc As cStrBuilder, rel As Boolean, usettk As Boolean) As String
    
    Dim sOut As New cStrBuilder, s() As String, i As Long, extra As String
    
    sOut.Append Space(8) & "self." & m_Base.Name & "List = " & m_List
    sOut.Append Space(8) & "self." & m_Base("variable") & " = StringVar(value=self." & m_Base.Name & "List[0])"
    
    extra = "self." & m_Base("variable") & ", *self." & m_Base.Name & "List"
    
    sOut.Append Space(8) & "self." & m_Base.Name & " = OptionMenu(self." & m_Base.Parent & IIf(Len(extra), ", ", "") & extra & ")"
    sOut.Append Space(8) & "self." & m_Base.Name & ".place(" & m_Base.GetPositionParams(rel) & ")"
    
    '�����¼�����������ܣ�����У�
    sCmdFunc.Append m_Base.CreateFuncDefOOP(m_Base("command"))
    
    If Len(m_Base("bindcommand")) Then                                          '����Ҫʹ��bind���󶨵������¼�����
        s = Split(m_Base("bindcommand"), ",")
        For i = 0 To UBound(s)
            s(i) = Trim(s(i))
            If Left(s(i), 1) = "<" And Right(s(i), 1) = ">" Then
                sOut.Append Space(8) & "self." & m_Base.Name & ".bind('" & s(i) & "', self." & m_Base.Name & "_" & Replace(Mid(s(i), 2, Len(s(i)) - 2), "-", "_") & ")"
                sCmdFunc.Append m_Base.CreateFuncDefOOP(m_Base.Name & "_" & Replace(Mid(s(i), 2, Len(s(i)) - 2), "-", "_"), "event")
            End If
        Next
    End If
    
    toStringOOP = sOut.toString(vbCrLf)
    
End Function


'���������Ҫ���ϵ������������ʼ��������
Public Sub InitConfig(o As Object, parentWidth As Long, parentHeight As Long)
    
    Dim i As Long, oList As Object, sList As String
    
    m_Base.Name = o.Properties("Name")
    
    '��������ѡ��ֵ
    Set oList = o.Properties("List")
    sList = "("
    i = IIf(o.Properties("Style") = 2, 1, 0)                                    ' 2-Dropdown Listʱ��һ��IndexedValueΪ�ؼ��������Դӵڶ��ʼ
    Do While True
        If oList.IndexedValue(i) = "" Then Exit Do
        sList = sList & "'" & oList.IndexedValue(i) & "',"
        i = i + 1
    Loop
    m_List = sList & IIf(sList = "(", "'Add items in design or code!',)", ")")
    
    m_dicTotal("x") = m_Base.toPixelX(o.Properties("Left"))
    m_dicTotal("y") = m_Base.toPixelY(o.Properties("Top"))
    m_dicTotal("width") = m_Base.toPixelX(o.Properties("Width"))
    m_dicTotal("height") = m_Base.toPixelY(o.Properties("Height"))
    m_dicTotal("relx") = Format(o.Properties("Left") / parentWidth, "0.###")
    m_dicTotal("rely") = Format(o.Properties("Top") / parentHeight, "0.###")
    m_dicTotal("relwidth") = Format(o.Properties("Width") / parentWidth, "0.###")
    m_dicTotal("relheight") = Format(o.Properties("Height") / parentHeight, "0.###")
    m_dicTotal("variable") = o.Properties("Name") & "Var"
    m_dicTotal("bindcommand") = ""
    
    '��Щ��Ĭ��ѡ���
    m_Base("x") = m_dicTotal("x")
    m_Base("y") = m_dicTotal("y")
    m_Base("width") = m_dicTotal("width")
    m_Base("height") = m_dicTotal("height")
    m_Base("relx") = m_dicTotal("relx")
    m_Base("rely") = m_dicTotal("rely")
    m_Base("relwidth") = m_dicTotal("relwidth")
    m_Base("relheight") = m_dicTotal("relheight")
    m_Base("variable") = m_dicTotal("variable")
    
End Sub

'��������ֵ�Ŀ���ֵ�б�
'����ֵ��0-û�п�ѡֵ��1-��һ���ϸ����ƵĿ�ѡֵ�б���2-���ṩ�Ŀ�ѡֵ�б��⣬�������ֶ���������ֵ
'�����sa()��ѡֵ�б�����
Public Function GetAttrValueList(sAttr As String, ByRef sa() As String) As Long
    GetAttrValueList = m_Base.GetAttrValueList(sAttr, sa)
End Function

Public Function Tips(sAttr As String) As String
    Tips = m_Base.Tips(sAttr)
End Function

Private Sub Class_Initialize()
    Set m_dicTotal = New Dictionary
    Set m_Base = New clsBaseControl
    m_Base.ctlType = "OptionMenu"
    m_Base.StyleName = "TMenubutton"
End Sub

'���û�ѡ������ø��µ������У�����Ϊʹ��"|"�ָ�ĺܶ������/ֵ��
Public Sub SetConfig(sAttrs As String)
    m_Base.SetConfig sAttrs
End Sub

'�޸Ļ����ӵ������������/ֵ��"|"�ָ�
Public Sub SetSingleConfig(sAttr As String)
    m_Base.SetSingleConfig sAttr
End Sub

'����һ�����ϣ�ÿ����Ŀ��Ԫ��"������|ֵ|�Ƿ�Ĭ��ѡ��"
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

'�������л�����
Public Function Serializer(vSer As clsSerialization)
    vSer.Serializer m_Base
End Function

Public Function Deserializer(vSer As clsSerialization)
    vSer.Deserializer m_Base
End Function

Public Property Get Description() As String
    Description = L("l_DescOptionmenu", "��Ͽ������ҪԤ������Ҫ��ʾ���ַ��б�����Ӧ��Tkinter��Optionmenu�ؼ���")
End Property

Public Property Let ScaleMode(nV As Long)
    m_Base.ScaleMode = nV
End Property

