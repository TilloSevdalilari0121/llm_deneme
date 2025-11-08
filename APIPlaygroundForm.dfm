object frmAPIPlayground: TfrmAPIPlayground
  Left = 0
  Top = 0
  Caption = 'API Playground'
  ClientHeight = 650
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 350
    Width = 900
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 305
    ExplicitWidth = 217
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 100
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblEndpoint: TLabel
      Left = 8
      Top = 8
      Width = 53
      Height = 15
      Caption = 'Endpoint:'
    end
    object lblMethod: TLabel
      Left = 8
      Top = 61
      Width = 47
      Height = 15
      Caption = 'Method:'
    end
    object lblTemplate: TLabel
      Left = 464
      Top = 8
      Width = 53
      Height = 15
      Caption = 'Template:'
    end
    object lblStatus: TLabel
      Left = 464
      Top = 64
      Width = 3
      Height = 15
    end
    object cmbEndpoint: TComboBox
      Left = 8
      Top = 29
      Width = 440
      Height = 23
      TabOrder = 0
      OnChange = cmbEndpointChange
    end
    object cmbMethod: TComboBox
      Left = 112
      Top = 58
      Width = 150
      Height = 23
      Style = csDropDownList
      TabOrder = 1
    end
    object btnSend: TButton
      Left = 268
      Top = 58
      Width = 90
      Height = 23
      Caption = 'Send'
      TabOrder = 2
      OnClick = btnSendClick
    end
    object btnClear: TButton
      Left = 364
      Top = 58
      Width = 90
      Height = 23
      Caption = 'Clear'
      TabOrder = 3
      OnClick = btnClearClick
    end
    object cmbTemplate: TComboBox
      Left = 464
      Top = 29
      Width = 300
      Height = 23
      Style = csDropDownList
      TabOrder = 4
    end
    object btnLoadTemplate: TButton
      Left = 770
      Top = 29
      Width = 120
      Height = 23
      Caption = 'Load Template'
      TabOrder = 5
      OnClick = btnLoadTemplateClick
    end
    object chkPrettyPrint: TCheckBox
      Left = 8
      Top = 82
      Width = 97
      Height = 17
      Caption = 'Pretty Print JSON'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
  end
  object pnlRequest: TPanel
    Left = 0
    Top = 100
    Width = 900
    Height = 250
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblRequest: TLabel
      Left = 8
      Top = 8
      Width = 74
      Height = 15
      Caption = 'Request Body:'
    end
    object memoRequest: TMemo
      Left = 8
      Top = 29
      Width = 884
      Height = 213
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object pnlResponse: TPanel
    Left = 0
    Top = 355
    Width = 900
    Height = 295
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lblResponse: TLabel
      Left = 8
      Top = 8
      Width = 54
      Height = 15
      Caption = 'Response:'
    end
    object memoResponse: TMemo
      Left = 8
      Top = 29
      Width = 884
      Height = 258
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
end
