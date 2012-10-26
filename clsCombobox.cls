VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsCombobox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'��Ͽ��࣬�������úͱ�����Ӧ�����Ժ�ֵ�������ɶ�ӦPYTHON��TKinter����

Private m_dicTotal As Dictionary                                                '����ȫ�������ԣ�����Ĭ��ֵ
Private m_Base As clsBaseControl                                                '�����ؼ���
Private m_List As String

'���PYTHON����,
'sCmdFunc: ����������¼������ص�����;
'rel:�Ƿ�ʹ���������,
'oop:�Ƿ�ʹ�����������
'usettk:�Ƿ�ʹ��TTK������չ
Public Function toString(ByRef sCmdFunc As cStrBuilder, rel As Boolean, oop As Boolean, usettk As Boolean) As String
    
    Dim sOut As New cStrBuilder
    
    '�ȴ��������б�
    If Len(m_Base("values")) Then
        If oop Then
            sOut.Append Space(8) & "self." & m_Base.Name & "List = " & m_List
        Else
            sOut.Append Space(4) & m_Base.Name & "List = " & m_List
        End If
        If Len(m_Base("textvariable")) Then m_Base("text") = GetFirstItemText()
    End If
    
    sOut.Append m_Base.toString(sCmdFunc, rel, oop, usettk)
    
    'Ĭ����������Ͽ���ʾ��һ��
    If Len(m_Base("values")) Then
        If Len(m_Base("textvariable")) Then
            m_Base.Remove ("text")
        Else
            If oop Then
                sOut.Append Space(8) & "self." & m_Base.Name & ".set(self." & m_Base.Name & "List[0])"
            Else
                sOut.Append Space(4) & m_Base.Name & ".set(" & m_Base.Name & "List[0])"
            End If
        End If
    End If
    
    toString = sOut.toString(vbCrLf)
    
End Function

'���������Ҫ���ϵ������������ʼ��������
Public Sub InitConfig(o As Object, parentWidth As Long, parentHeight As Long)
    
    Dim i As Long, oList As Object, sList As String
    
    m_Base.Name = o.Properties("Name")
    
    '��������ѡ��ֵ
    Set oList = o.Properties("List")
    sList = "["
    i = IIf(o.Properties("Style") = 2, 1, 0)                                    ' 2-Dropdown Listʱ��һ��IndexedValueΪ�ؼ��������Դӵڶ��ʼ
    Do While True
        If oList.IndexedValue(i) = "" Then Exit Do
        sList = sList & "'" & oList.IndexedValue(i) & "',"
        i = i + 1
    Loop
    m_List = sList & IIf(sList = "[", "'Add items in design or code!',]", "]")
    
    m_dicTotal("x") = m_Base.toPixelX(o.Properties("Left"))
    m_dicTotal("y") = m_Base.toPixelY(o.Properties("Top"))
    m_dicTotal("width") = m_Base.toPixelX(o.Properties("Width"))
    m_dicTotal("height") = m_Base.toPixelY(o.Properties("Height"))
    m_dicTotal("relx") = Format(o.Properties("Left") / parentWidth, "0.###")
    m_dicTotal("rely") = Format(o.Properties("Top") / parentHeight, "0.###")
    m_dicTotal("relwidth") = Format(o.Properties("Width") / parentWidth, "0.###")
    m_dicTotal("relheight") = Format(o.Properties("Height") / parentHeight, "0.###")
    m_dicTotal("displayrows") = ""
    m_dicTotal("textvariable") = m_Base.Name & "Var"
    m_dicTotal("fg") = m_Base.ColorToRGBStr(o.Properties("ForeColor"))
    m_dicTotal("bg") = m_Base.ColorToRGBStr(o.Properties("BackColor"))
    m_dicTotal("bd") = "1"
    m_dicTotal("relief") = "SUNKEN"
    m_dicTotal("justify") = "'left'"
    m_dicTotal("state") = IIf(o.Properties("Enabled"), IIf(o.Properties("Locked") Or o.Properties("Style") = 2, "'readonly'", "'normal'"), "'disabled'")
    m_dicTotal("values") = m_Base.Name & "List"
    m_dicTotal("font") = "size=" & Round(o.Properties("Font")("Size")) & ",weight=" & IIf(o.Properties("Font")("Bold"), "'bold'", "'normal'") & ",slant=" & IIf(o.Properties("Font")("Italic"), "'italic'", "'roman'")
    m_dicTotal("takefocus") = IIf(o.Properties("TabStop"), 1, 0)
    m_dicTotal("exportselection") = ""
    m_dicTotal("postcommand") = ""
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
    m_Base("values") = m_dicTotal("values")
    If m_dicTotal("fg") <> "" Then m_Base("fg") = m_dicTotal("fg")
    If m_dicTotal("bg") <> "" Then m_Base("bg") = m_dicTotal("bg")
    If m_dicTotal("state") <> "'normal'" Then m_Base("state") = m_dicTotal("state")
    If m_dicTotal("font") <> "size=9,weight='normal',slant='roman'" Then m_Base("font") = m_dicTotal("font")
    If m_dicTotal("takefocus") = 0 Then m_Base("takefocus") = m_dicTotal("takefocus")
    
End Sub

'��������ֵ�Ŀ���ֵ�б�
'����ֵ��0-û�п�ѡֵ��1-��һ���ϸ����ƵĿ�ѡֵ�б���2-���ṩ�Ŀ�ѡֵ�б��⣬�������ֶ���������ֵ
'�����sa()��ѡֵ�б�����
Public Function GetAttrValueList(sAttr As String, ByRef sa() As String) As Long
    
    GetAttrValueList = 1
    Select Case sAttr
        Case "state"
            sa = Split("'normal','readonly','disabled'", ",")
        Case "exportselection"
            sa = Split("False,True", ",")
        Case Else
            GetAttrValueList = m_Base.GetAttrValueList(sAttr, sa)
    End Select
End Function

Public Function Tips(sAttr As String) As String
    
    Tips = sAttr & vbCrLf
    Select Case sAttr:
    Case "displayrows":
        Tips = Tips & L("l_TipDisplayRows", "ָ��Ҫ��ʾ������")
    Case "state":
        Tips = Tips & L("l_TipStateHasRO", "�ؼ�״̬����ʹ����������������ѡֵ�У�'normal', 'readonly', 'disabled'")
    Case "values":
        Tips = Tips & L("l_TipValues", "�ؼ��������ı��б���������ֵ����Ϊ��������Ϊһ���б����������Ҫ����ʱ���Ӻ�ɾ�������ı��б�����Ҫ����ʹ����Ͽ��configure��������values���ԡ�")
    Case "postcommand":
        Tips = Tips & L("l_TipPostCmd", "ÿ�������б���ǰ���ô˻ص�������")
    Case "exportselection":
        Tips = Tips & L("l_TipExportSelection", "Ĭ��ΪFalse��ΪTrueʱ������Window Manager selection��")
    Case Else:
        Tips = m_Base.Tips(sAttr)
    End Select
    
End Function

'��ȡ�����б���һ����ı�
Private Function GetFirstItemText() As String
    If Len(m_List) Then
        GetFirstItemText = Mid(m_List, 3, InStr(1, m_List, ",") - 4)
    Else
        GetFirstItemText = ""
    End If
End Function

Private Sub Class_Initialize()
    
    Set m_dicTotal = New Dictionary
    Set m_Base = New clsBaseControl
    m_Base.ctlType = "Combobox"
    m_Base.StyleName = "TCombobox"
    
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

'���û�ѡ������ø��µ������У�����Ϊʹ��"|"�ָ�ĺܶ������/ֵ��
Public Sub SetConfig(sAttrs As String)
    m_Base.SetConfig sAttrs
End Sub

'�޸Ļ����ӵ������������/ֵ��"|"�ָ�
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

'�������л�����
Public Function Serializer(vSer As clsSerialization)
    vSer.Serializer m_Base
End Function

Public Function Deserializer(vSer As clsSerialization)
    vSer.Deserializer m_Base
End Function

Public Property Get Description() As String
    Description = L("l_DescCombobox", "�ı���Ͽ���󣬶�Ӧ��tkinter.ttk��Combobox�ؼ���")
End Property

Public Property Let ScaleMode(nV As Long)
    m_Base.ScaleMode = nV
End Property


