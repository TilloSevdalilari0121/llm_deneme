object frmCodeExecution: TfrmCodeExecution
  Left = 0
  Top = 0
  Caption = 'Code Execution'
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
  object Splitter1: TSplitter
    Left = 0
    Top = 370
    Width = 900
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 315
    ExplicitWidth = 289
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblLanguage: TLabel
      Left = 8
      Top = 8
      Width = 56
      Height = 15
      Caption = 'Language:'
    end
    object lblStatus: TLabel
      Left = 8
      Top = 48
      Width = 3
      Height = 15
    end
    object cmbLanguage: TComboBox
      Left = 8
      Top = 29
      Width = 300
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cmbLanguageChange
    end
    object btnRun: TButton
      Left = 320
      Top = 29
      Width = 120
      Height = 23
      Caption = 'Run Code'
      TabOrder = 1
      OnClick = btnRunClick
    end
    object btnClear: TButton
      Left = 446
      Top = 29
      Width = 120
      Height = 23
      Caption = 'Clear'
      TabOrder = 2
      OnClick = btnClearClick
    end
    object btnStop: TButton
      Left = 572
      Top = 29
      Width = 120
      Height = 23
      Caption = 'Stop'
      TabOrder = 3
      OnClick = btnStopClick
    end
    object chkSandbox: TCheckBox
      Left = 704
      Top = 31
      Width = 188
      Height = 17
      Caption = 'Sandbox Mode (Recommended)'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object pnlCode: TPanel
    Left = 0
    Top = 70
    Width = 900
    Height = 300
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblCode: TLabel
      Left = 8
      Top = 8
      Width = 71
      Height = 15
      Caption = 'Code Editor:'
    end
    object memoCode: TMemo
      Left = 8
      Top = 29
      Width = 884
      Height = 263
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
  object pnlOutput: TPanel
    Left = 0
    Top = 375
    Width = 900
    Height = 225
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lblOutput: TLabel
      Left = 8
      Top = 8
      Width = 43
      Height = 15
      Caption = 'Output:'
    end
    object memoOutput: TMemo
      Left = 8
      Top = 29
      Width = 884
      Height = 188
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
