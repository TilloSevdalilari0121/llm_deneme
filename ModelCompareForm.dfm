object frmModelCompare: TfrmModelCompare
  Left = 0
  Top = 0
  Caption = 'Model Comparison'
  ClientHeight = 600
  ClientWidth = 1000
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
    Width = 1000
    Height = 150
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblModel1: TLabel
      Left = 8
      Top = 8
      Width = 49
      Height = 15
      Caption = 'Model 1:'
    end
    object lblModel2: TLabel
      Left = 344
      Top = 8
      Width = 49
      Height = 15
      Caption = 'Model 2:'
    end
    object lblModel3: TLabel
      Left = 680
      Top = 8
      Width = 49
      Height = 15
      Caption = 'Model 3:'
    end
    object cmbModel1: TComboBox
      Left = 8
      Top = 29
      Width = 300
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object cmbModel2: TComboBox
      Left = 344
      Top = 29
      Width = 300
      Height = 23
      Style = csDropDownList
      TabOrder = 1
    end
    object cmbModel3: TComboBox
      Left = 680
      Top = 29
      Width = 300
      Height = 23
      Style = csDropDownList
      TabOrder = 2
    end
    object chkEnableModel3: TCheckBox
      Left = 680
      Top = 58
      Width = 150
      Height = 17
      Caption = 'Enable 3rd Model'
      TabOrder = 3
      OnClick = chkEnableModel3Click
    end
    object memoPrompt: TMemo
      Left = 8
      Top = 81
      Width = 972
      Height = 40
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object btnCompare: TButton
      Left = 8
      Top = 127
      Width = 150
      Height = 25
      Caption = 'Compare'
      TabOrder = 5
      OnClick = btnCompareClick
    end
    object btnClear: TButton
      Left = 164
      Top = 127
      Width = 150
      Height = 25
      Caption = 'Clear'
      TabOrder = 6
      OnClick = btnClearClick
    end
  end
  object pnlModel1: TPanel
    Left = 0
    Top = 150
    Width = 320
    Height = 450
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object lblStats1: TLabel
      Left = 8
      Top = 8
      Width = 53
      Height = 15
      Caption = 'Waiting...'
    end
    object memoResponse1: TRichEdit
      Left = 8
      Top = 29
      Width = 300
      Height = 413
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Splitter1: TSplitter
    Left = 320
    Top = 150
    Width = 5
    Height = 450
    ExplicitLeft = 280
    ExplicitTop = 112
    ExplicitHeight = 100
  end
  object pnlModel2: TPanel
    Left = 325
    Top = 150
    Width = 320
    Height = 450
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
    object lblStats2: TLabel
      Left = 8
      Top = 8
      Width = 53
      Height = 15
      Caption = 'Waiting...'
    end
    object memoResponse2: TRichEdit
      Left = 8
      Top = 29
      Width = 300
      Height = 413
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Splitter2: TSplitter
    Left = 645
    Top = 150
    Width = 5
    Height = 450
    ExplicitLeft = 576
    ExplicitTop = 184
    ExplicitHeight = 100
  end
  object pnlModel3: TPanel
    Left = 650
    Top = 150
    Width = 350
    Height = 450
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 5
    object lblStats3: TLabel
      Left = 8
      Top = 8
      Width = 53
      Height = 15
      Caption = 'Waiting...'
    end
    object memoResponse3: TRichEdit
      Left = 8
      Top = 29
      Width = 334
      Height = 413
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
