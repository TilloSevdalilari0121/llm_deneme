object frmModelManager: TfrmModelManager
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Model Manager'
  ClientHeight = 500
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 700
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnAddModel: TButton
      Left = 10
      Top = 15
      Width = 100
      Height = 30
      Caption = 'Add Model...'
      TabOrder = 0
      OnClick = btnAddModelClick
    end
    object btnRemoveModel: TButton
      Left = 120
      Top = 15
      Width = 120
      Height = 30
      Caption = 'Remove Model'
      TabOrder = 1
      OnClick = btnRemoveModelClick
    end
    object btnScanOllama: TButton
      Left = 250
      Top = 15
      Width = 100
      Height = 30
      Caption = 'Scan Ollama'
      TabOrder = 2
      OnClick = btnScanOllamaClick
    end
    object btnScanLMStudio: TButton
      Left = 360
      Top = 15
      Width = 110
      Height = 30
      Caption = 'Scan LM Studio'
      TabOrder = 3
      OnClick = btnScanLMStudioClick
    end
    object btnScanJan: TButton
      Left = 480
      Top = 15
      Width = 80
      Height = 30
      Caption = 'Scan Jan'
      TabOrder = 4
      OnClick = btnScanJanClick
    end
    object btnRefresh: TButton
      Left = 570
      Top = 15
      Width = 80
      Height = 30
      Caption = 'Refresh'
      TabOrder = 5
      OnClick = btnRefreshClick
    end
  end
  object lstModels: TListBox
    Left = 0
    Top = 60
    Width = 700
    Height = 380
    Align = alClient
    ItemHeight = 15
    TabOrder = 1
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 440
    Width = 700
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblInfo: TLabel
      Left = 20
      Top = 20
      Width = 87
      Height = 15
      Caption = 'Total Models: 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnClose: TButton
      Left = 580
      Top = 15
      Width = 100
      Height = 30
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
end
