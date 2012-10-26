VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsStatusbar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'״̬���࣬��ΪTK��TTK�ⶼû��״̬���ؼ��������Լ�ʵ��һ��״̬���ؼ�

'һ���򵥵�״̬��python�ؼ��ඨ�壬��ΪVB������̫������з������Էֳ������֣��ڳ���������������
'�˿ؼ���ʹ�÷�����
'  statusbar = Statusbar(top)  #��������һ�������״̬��
'  statusbar = Statusbar(top, slots=[30,10,]) #������������ǰ�������ȷֱ�Ϊ30,10���أ�������ռ��ʣ��ռ�
'  statusbar.pack(side=BOTTOM, fill=X)   #�����ڴ���������
'  statusbar.set(0,'Demo mode')  #���õ�һ�����������
Const DefineStatusbar1  As String = "class Statusbar(Frame):" & vbCrLf & _
"    """ & """" & """A Simple Statusbar" & vbCrLf & _
"    Usage:self.status = Statusbar(self.top, panelwidths=(15,5,))" & vbCrLf & _
"          self.status.pack(side=BOTTOM, fill=X)" & vbCrLf & _
"          self.status.set(0,'Demo mode')" & vbCrLf & _
"          self.status.text('Demo mode')" & vbCrLf & _
"    """ & """" & """" & vbCrLf & _
"    def __init__(self, master, **kw):" & vbCrLf & _
"        """ & """" & """Options:" & vbCrLf & _
"        panelwidths - a tuple of width of panels, atual number of panels is len(panelwidths)+1." & vbCrLf & _
"        """ & """" & """" & vbCrLf & _
"        Frame.__init__(self, master)" & vbCrLf & _
"        panelwidths = kw['panelwidths'] if 'panelwidths' in kw else []" & vbCrLf & _
"        self.lbls = []" & vbCrLf & _
"        for pnlwidth in panelwidths:" & vbCrLf & _
"            lbl = Label(self, width=pnlwidth, anchor=W, relief=SUNKEN)" & vbCrLf & _
"            self.lbls.append(lbl)" & vbCrLf & _
"            lbl.pack(side=LEFT, fill=Y)" & vbCrLf & _
"        lbl = Label(self, anchor=W, relief=SUNKEN)" & vbCrLf & _
"        self.lbls.append(lbl)" & vbCrLf & _
"        lbl.pack(fill=BOTH, expand=1)" & vbCrLf & vbCrLf

Const DefineStatusbar2 As String = "    def set(self, panel, format, *args):" & vbCrLf & _
"        if panel >= len(self.lbls): raise IndexError" & vbCrLf & _
"        self.lbls[panel]['text'] = format % args" & vbCrLf & _
"        self.lbls[panel].update_idletasks()" & vbCrLf & vbCrLf & _
"    text = lambda self,format,*args : self.set(0,format,*args)" & vbCrLf & vbCrLf & _
"    def panelwidth(self, panel, width=None):" & vbCrLf & _
"        if panel >= len(self.lbls): raise IndexError" & vbCrLf & _
"        if width is None:" & vbCrLf & _
"            panelwidth = self.lbls[panel]['width']" & vbCrLf & _
"        else:" & vbCrLf & _
"            self.lbls[panel]['width'] = width" & vbCrLf & vbCrLf & _
"    def clear(self):" & vbCrLf & _
"        for panel in self.lbls:" & vbCrLf & _
"            panel.config(text='')" & vbCrLf & _
"            panel.update_idletasks()" & vbCrLf & vbCrLf

Private m_Base As clsBaseControl

'���״̬���ؼ��Ķ���
Public Property Get WidgetCode() As String
    WidgetCode = DefineStatusbar1 & DefineStatusbar2
End Property

'���PYTHON����,
'sCmdFunc: ����������¼������ص�����;
'rel:�Ƿ�ʹ���������,
'oop:�Ƿ�ʹ�����������
'usettk:�Ƿ�ʹ��TTK������չ
Public Function toString(ByRef sCmdFunc As cStrBuilder, rel As Boolean, oop As Boolean, usettk As Boolean) As String
    
    Dim sOut As New cStrBuilder
    
    If oop Then
        sOut.Append Space(8) & "self." & m_Base.Name & " = Statusbar(self." & m_Base.Parent
        sOut.Append IIf(Len(m_Base("panelwidths")), ", panelwidths=" & m_Base("panelwidths"), "") & ")" & vbCrLf
        If Len(m_Base("side")) Then
            sOut.Append Space(8) & "self." & m_Base.Name & ".pack(side=" & m_Base("side") & ", fill=X)"
        ElseIf rel Then
            sOut.Append Space(8) & "self." & m_Base.Name & ".place(relx=" & m_Base("relx") & ", rely=" & m_Base("rely")
            sOut.Append ", relwidth=" & m_Base("relwidth") & ", relheight=" & m_Base("relheight") & ")"
        Else
            sOut.Append Space(8) & "self." & m_Base.Name & ".place(x=" & m_Base("x") & ", y=" & m_Base("y")
            sOut.Append ", width=" & m_Base("width") & ", height=" & m_Base("height") & ")"
        End If
    Else
        sOut.Append Space(4) & m_Base.Name & " = Statusbar(" & m_Base.Parent
        sOut.Append IIf(Len(m_Base("panelwidths")), ", panelwidths=" & m_Base("panelwidths"), "") & ")" & vbCrLf
        If Len(m_Base("side")) Then
            sOut.Append Space(4) & m_Base.Name & ".pack(side=" & m_Base("side") & ", fill=X)"
        ElseIf rel Then
            sOut.Append Space(4) & m_Base.Name & ".place(relx=" & m_Base("relx") & ", rely=" & m_Base("rely")
            sOut.Append ", relwidth=" & m_Base("relwidth") & ", relheight=" & m_Base("relheight") & ")"
        Else
            sOut.Append Space(4) & m_Base.Name & ".place(x=" & m_Base("x") & ", y=" & m_Base("y")
            sOut.Append ", width=" & m_Base("width") & ", height=" & m_Base("height") & ")"
        End If
    End If
    
    toString = sOut.toString("")
    
End Function

'���������Ҫ���ϵ������������ʼ��������
Public Sub InitConfig(o As Object, parentWidth As Long, parentHeight As Long)
    
    Dim i As Long, nCnt As Long, s As String, Panels As IPanels
    
    m_Base.Name = o.Properties("Name")
    
    m_Base("x") = m_Base.toPixelX(o.Properties("Left"))
    m_Base("y") = m_Base.toPixelY(o.Properties("Top"))
    m_Base("width") = m_Base.toPixelX(o.Properties("Width"))
    m_Base("height") = m_Base.toPixelY(o.Properties("Height"))
    m_Base("relx") = Format(o.Properties("Left") / parentWidth, "0.###")
    m_Base("rely") = Format(o.Properties("Top") / parentHeight, "0.###")
    m_Base("relwidth") = Format(o.Properties("Width") / parentWidth, "0.###")
    m_Base("relheight") = Format(o.Properties("Height") / parentHeight, "0.###")
    
    If o.Properties("Align") = vbAlignTop Then
        m_Base("side") = "TOP"
    ElseIf o.Properties("Align") = vbAlignBottom Then
        m_Base("side") = "BOTTOM"
    End If
    
    m_Base("panelwidths") = ""
    Set Panels = o.Properties("Panels").object
    nCnt = Panels.Count
    If o.Properties("Style") = sbrNormal And nCnt > 0 Then
        For i = 1 To nCnt
            s = s & Round(m_Base.toPixelX(Panels(i).MinWidth) / CharWidth()) & ","
        Next
        
        If Len(s) Then
            m_Base("panelwidths") = "(" & s & ")"
        End If
    End If
    
End Sub

'��������ֵ�Ŀ���ֵ�б�
'����ֵ��0-û�п�ѡֵ��1-��һ���ϸ����ƵĿ�ѡֵ�б���2-���ṩ�Ŀ�ѡֵ�б��⣬�������ֶ���������ֵ
'�����sa()��ѡֵ�б�����
Public Function GetAttrValueList(sAttr As String, ByRef sa() As String) As Long
    If sAttr = "side" Then
        GetAttrValueList = 2
        sa = Split("TOP,BOTTOM", ",")
    Else
        GetAttrValueList = m_Base.GetAttrValueList(sAttr, sa)
    End If
End Function

Public Function Tips(sAttr As String) As String
    
    If sAttr = "side" Then
        Tips = sAttr & vbCrLf & L("l_TipSide", "״̬������λ��\n��ѡֵ�У�TOP,BOTTOM,��������Է������κ�λ�á�")
    ElseIf sAttr = "panelwidths" Then
        Tips = sAttr & vbCrLf & L("l_TipPanelWidths", "һ��Ԫ����б���״̬��������Ŀ��ȣ��ַ����������һ����������ռ��ʣ��ռ䣬����Ҫ�г���")
    Else
        Tips = m_Base.Tips(sAttr)
    End If
    
End Function

'���û�ѡ������ø��µ������У�����Ϊʹ��"|"�ָ�ĺܶ������/ֵ��
Public Sub SetConfig(sAttrs As String)

    Dim sa() As String, i As Long
    
    sa = Split(sAttrs, "|")
    Debug.Assert (UBound(sa) Mod 1 = 0)
    
    'm_Base.RemoveAll
    
    For i = 0 To UBound(sa) - 1 Step 2
        SetSingleConfig sa(i) & "|" & sa(i + 1)
    Next
    
End Sub

'�޸Ļ����ӵ������������/ֵ��"|"�ָ�
Public Sub SetSingleConfig(sAttr As String)
    
    Dim sa() As String, s As String
    
    sa = Split(sAttr, "|")
    Debug.Assert (UBound(sa) = 1)
    
    If sa(0) = "panelwidths" Then
        s = Replace(Replace(sa(1), "'", ""), " ", "")
        s = Replace(Replace(s, "[", "("), "]", ")")
        If Left$(s, 1) <> "(" And Right$(s, 1) <> ")" Then
            If InStr(1, s, ",") Then 'ʹ�ö��ŷָ�
                m_Base("panelwidths") = "(" & s & ")"
            ElseIf InStr(1, s, " ") Then 'ʹ�ÿո�ָ�
                s = Replace(Replace(s, "  ", " "), " ", ",")
                m_Base("panelwidths") = "(" & s & ")"
            Else
                m_Base("panelwidths") = s
            End If
        Else
            m_Base("panelwidths") = s
        End If
    Else
        m_Base(sa(0)) = sa(1)
    End If
    
End Sub

'����һ�����ϣ�ÿ����Ŀ��Ԫ��"������|ֵ|�Ƿ�Ĭ��ѡ��"
'�����������������������Բ����б���
Public Function Allitems() As Collection
    Dim re As Collection, k As Variant, ks As Collection
    
    Set re = New Collection
    
    Set ks = m_Base.Keys
    For Each k In ks
        re.Add k & "|" & m_Base(k) & "|1"
    Next
    
    Set Allitems = re
    
End Function

Private Sub Class_Initialize()
    Set m_Base = New clsBaseControl
    m_Base.ctlType = "Statusbar"
    m_Base.StyleName = ""
End Sub

Private Sub Class_Terminate()
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
    Description = L("l_DescStatusbar", "״̬������Ϊ�Զ���ؼ��������ö������ֱ��ʹ�ÿؼ���set()��������״̬��ʾ��")
End Property

Public Property Let ScaleMode(nV As Long)
    m_Base.ScaleMode = nV
End Property
