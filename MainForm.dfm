object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Universal LLM Studio'
  ClientHeight = 800
  ClientWidth = 1400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object splSidebar: TSplitter
    Left = 250
    Top = 80
    Width = 5
    Height = 680
  end
  object pnlSidebar: TPanel
    Left = 0
    Top = 80
    Width = 250
    Height = 680
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lstModules: TListBox
      Left = 0
      Top = 0
      Width = 250
      Height = 680
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemHeight = 17
      ParentFont = False
      TabOrder = 0
      OnClick = lstModulesClick
    end
  end
  object pnlMain: TPanel
    Left = 255
    Top = 80
    Width = 1145
    Height = 680
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1400
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblTitle: TLabel
      Left = 20
      Top = 15
      Width = 220
      Height = 28
      Caption = 'Universal LLM Studio'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblProvider: TLabel
      Left = 300
      Top = 15
      Width = 50
      Height = 15
      Caption = 'Provider:'
    end
    object lblModel: TLabel
      Left = 500
      Top = 15
      Width = 38
      Height = 15
      Caption = 'Model:'
    end
    object cmbProvider: TComboBox
      Left = 300
      Top = 35
      Width = 180
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cmbProviderChange
    end
    object cmbModel: TComboBox
      Left = 500
      Top = 35
      Width = 300
      Height = 23
      Style = csDropDownList
      TabOrder = 1
    end
    object btnRefreshModels: TButton
      Left = 810
      Top = 34
      Width = 90
      Height = 25
      Caption = 'Refresh'
      TabOrder = 2
      OnClick = btnRefreshModelsClick
    end
    object btnSettings: TButton
      Left = 1150
      Top = 20
      Width = 100
      Height = 35
      Caption = 'Settings'
      TabOrder = 3
      OnClick = btnSettingsClick
    end
    object btnTheme: TButton
      Left = 1260
      Top = 20
      Width = 100
      Height = 35
      Caption = 'Theme'
      TabOrder = 4
      OnClick = btnThemeClick
    end
  end
  object pnlStatus: TPanel
    Left = 0
    Top = 760
    Width = 1400
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object lblStatus: TLabel
      Left = 20
      Top = 12
      Width = 70
      Height = 15
      Caption = 'Status: Ready'
    end
  end
end
