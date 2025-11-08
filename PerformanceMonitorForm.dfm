object frmPerformanceMonitor: TfrmPerformanceMonitor
  Left = 0
  Top = 0
  Caption = 'Performance Monitor'
  ClientHeight = 600
  ClientWidth = 900
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
    Width = 900
    Height = 120
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblFilter: TLabel
      Left = 8
      Top = 8
      Width = 32
      Height = 15
      Caption = 'Filter:'
    end
    object lblTotalRequests: TLabel
      Left = 8
      Top = 64
      Width = 91
      Height = 15
      Caption = 'Total Requests: 0'
    end
    object lblTotalTokens: TLabel
      Left = 200
      Top = 64
      Width = 78
      Height = 15
      Caption = 'Total Tokens: 0'
    end
    object lblAvgTokens: TLabel
      Left = 8
      Top = 85
      Width = 125
      Height = 15
      Caption = 'Avg Tokens/Request: 0'
    end
    object lblAvgDuration: TLabel
      Left = 200
      Top = 85
      Width = 88
      Height = 15
      Caption = 'Avg Duration: 0s'
    end
    object cmbFilter: TComboBox
      Left = 8
      Top = 29
      Width = 200
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cmbFilterChange
    end
    object btnRefresh: TButton
      Left = 214
      Top = 29
      Width = 100
      Height = 23
      Caption = 'Refresh'
      TabOrder = 1
      OnClick = btnRefreshClick
    end
    object btnClear: TButton
      Left = 320
      Top = 29
      Width = 100
      Height = 23
      Caption = 'Clear Logs'
      TabOrder = 2
      OnClick = btnClearClick
    end
    object btnExport: TButton
      Left = 426
      Top = 29
      Width = 100
      Height = 23
      Caption = 'Export CSV'
      TabOrder = 3
      OnClick = btnExportClick
    end
  end
  object pnlStats: TPanel
    Left = 0
    Top = 120
    Width = 900
    Height = 480
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblLogs: TLabel
      Left = 8
      Top = 8
      Width = 103
      Height = 15
      Caption = 'Performance Logs:'
    end
    object lstLogs: TListView
      Left = 8
      Top = 29
      Width = 884
      Height = 443
      Columns = <>
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object SaveDialog: TSaveDialog
    Left = 824
    Top = 24
  end
end
