object frmBenchmark: TfrmBenchmark
  Left = 0
  Top = 0
  Caption = 'Model Benchmark'
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
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 200
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblModel: TLabel
      Left = 8
      Top = 8
      Width = 38
      Height = 15
      Caption = 'Model:'
    end
    object lblTestType: TLabel
      Left = 8
      Top = 61
      Width = 52
      Height = 15
      Caption = 'Test Type:'
    end
    object lblPrompt: TLabel
      Left = 8
      Top = 114
      Width = 66
      Height = 15
      Caption = 'Test Prompt:'
    end
    object lblStatus: TLabel
      Left = 424
      Top = 35
      Width = 3
      Height = 15
    end
    object cmbModel: TComboBox
      Left = 8
      Top = 29
      Width = 400
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object cmbTestType: TComboBox
      Left = 8
      Top = 82
      Width = 400
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = cmbTestTypeChange
    end
    object btnRun: TButton
      Left = 424
      Top = 8
      Width = 150
      Height = 25
      Caption = 'Run Benchmark'
      TabOrder = 2
      OnClick = btnRunClick
    end
    object btnClear: TButton
      Left = 580
      Top = 8
      Width = 150
      Height = 25
      Caption = 'Clear Results'
      TabOrder = 3
      OnClick = btnClearClick
    end
    object memoPrompt: TMemo
      Left = 8
      Top = 135
      Width = 884
      Height = 57
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object progressBench: TProgressBar
      Left = 424
      Top = 61
      Width = 468
      Height = 17
      TabOrder = 5
      Visible = False
    end
  end
  object pnlResults: TPanel
    Left = 0
    Top = 200
    Width = 900
    Height = 450
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblResults: TLabel
      Left = 8
      Top = 8
      Width = 95
      Height = 15
      Caption = 'Benchmark Results:'
    end
    object lblResponse: TLabel
      Left = 8
      Top = 194
      Width = 86
      Height = 15
      Caption = 'Last Response:'
    end
    object lstResults: TListView
      Left = 8
      Top = 29
      Width = 884
      Height = 150
      Columns = <>
      TabOrder = 0
      ViewStyle = vsReport
    end
    object memoResponse: TMemo
      Left = 8
      Top = 215
      Width = 884
      Height = 227
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
end
