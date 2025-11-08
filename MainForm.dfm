object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Local Model Runner'
  ClientHeight = 700
  ClientWidth = 1200
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object splConversations: TSplitter
    Left = 250
    Top = 60
    Width = 5
    Height = 640
    ExplicitLeft = 0
    ExplicitTop = 50
    ExplicitHeight = 600
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1200
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblModel: TLabel
      Left = 16
      Top = 10
      Width = 72
      Height = 15
      Caption = 'Model: None'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblStatus: TLabel
      Left = 16
      Top = 35
      Width = 70
      Height = 15
      Caption = 'Status: Ready'
    end
    object cmbModels: TComboBox
      Left = 300
      Top = 15
      Width = 300
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object btnLoadModel: TButton
      Left = 610
      Top = 14
      Width = 100
      Height = 25
      Caption = 'Load Model'
      TabOrder = 1
      OnClick = btnLoadModelClick
    end
    object btnSettings: TButton
      Left = 720
      Top = 14
      Width = 80
      Height = 25
      Caption = 'Settings'
      TabOrder = 2
      OnClick = btnSettingsClick
    end
    object btnTheme: TButton
      Left = 810
      Top = 14
      Width = 80
      Height = 25
      Caption = 'Theme'
      TabOrder = 3
      OnClick = btnThemeClick
    end
    object btnModels: TButton
      Left = 900
      Top = 14
      Width = 80
      Height = 25
      Caption = 'Models'
      TabOrder = 4
      OnClick = btnModelsClick
    end
    object btnWorkspace: TButton
      Left = 990
      Top = 14
      Width = 90
      Height = 25
      Caption = 'Workspace'
      TabOrder = 5
      OnClick = btnWorkspaceClick
    end
  end
  object pnlSidebar: TPanel
    Left = 0
    Top = 60
    Width = 250
    Height = 640
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object lstConversations: TListBox
      Left = 0
      Top = 50
      Width = 250
      Height = 590
      Align = alClient
      ItemHeight = 15
      TabOrder = 0
      OnClick = lstConversationsClick
    end
    object pnlToolbar: TPanel
      Left = 0
      Top = 0
      Width = 250
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object btnNewChat: TButton
        Left = 10
        Top = 10
        Width = 100
        Height = 30
        Caption = 'New Chat'
        TabOrder = 0
        OnClick = btnNewChatClick
      end
      object btnDeleteChat: TButton
        Left = 120
        Top = 10
        Width = 100
        Height = 30
        Caption = 'Delete Chat'
        TabOrder = 1
        OnClick = btnDeleteChatClick
      end
    end
  end
  object pnlChat: TPanel
    Left = 255
    Top = 60
    Width = 945
    Height = 490
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object memoChat: TRichEdit
      Left = 0
      Top = 40
      Width = 945
      Height = 450
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 945
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object btnClearChat: TButton
        Left = 10
        Top = 7
        Width = 100
        Height = 28
        Caption = 'Clear Chat'
        TabOrder = 0
        OnClick = btnClearChatClick
      end
      object chkCodeMode: TCheckBox
        Left = 120
        Top = 12
        Width = 150
        Height = 17
        Caption = 'Enable Code Mode'
        TabOrder = 1
      end
    end
  end
  object pnlInput: TPanel
    Left = 255
    Top = 550
    Width = 945
    Height = 150
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object memoInput: TMemo
      Left = 0
      Top = 0
      Width = 825
      Height = 150
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        '')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnKeyDown = memoInputKeyDown
    end
    object Panel2: TPanel
      Left = 825
      Top = 0
      Width = 120
      Height = 150
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnSend: TButton
        Left = 10
        Top = 10
        Width = 100
        Height = 40
        Caption = 'Send (Ctrl+Enter)'
        TabOrder = 0
        OnClick = btnSendClick
      end
      object btnStop: TButton
        Left = 10
        Top = 60
        Width = 100
        Height = 40
        Caption = 'Stop'
        TabOrder = 1
        OnClick = btnStopClick
      end
    end
  end
end
