object frmModelManager: TfrmModelManager
  Left = 0
  Top = 0
  Caption = 'Model Manager'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 120
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblModelName: TLabel
      Left = 8
      Top = 8
      Width = 162
      Height = 15
      Caption = 'Model Name (e.g., llama2:7b):'
    end
    object lblProgress: TLabel
      Left = 8
      Top = 93
      Width = 3
      Height = 15
    end
    object edtModelName: TEdit
      Left = 8
      Top = 29
      Width = 400
      Height = 23
      TabOrder = 0
    end
    object btnPull: TButton
      Left = 414
      Top = 29
      Width = 120
      Height = 23
      Caption = 'Pull Model'
      TabOrder = 1
      OnClick = btnPullClick
    end
    object btnRefresh: TButton
      Left = 540
      Top = 29
      Width = 120
      Height = 23
      Caption = 'Refresh List'
      TabOrder = 2
      OnClick = btnRefreshClick
    end
    object btnDelete: TButton
      Left = 666
      Top = 29
      Width = 120
      Height = 23
      Caption = 'Delete Selected'
      TabOrder = 3
      OnClick = btnDeleteClick
    end
    object progressDownload: TProgressBar
      Left = 8
      Top = 58
      Width = 778
      Height = 25
      TabOrder = 4
      Visible = False
    end
  end
  object pnlModels: TPanel
    Left = 0
    Top = 120
    Width = 800
    Height = 480
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblInfo: TLabel
      Left = 8
      Top = 328
      Width = 86
      Height = 15
      Caption = 'Model Info/Help:'
    end
    object lstModels: TListView
      Left = 8
      Top = 8
      Width = 784
      Height = 310
      Columns = <>
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lstModelsClick
    end
    object memoInfo: TMemo
      Left = 8
      Top = 349
      Width = 784
      Height = 123
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
end
