object frmPromptLibrary: TfrmPromptLibrary
  Left = 0
  Top = 0
  Caption = 'Prompt Library'
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
    Left = 220
    Top = 0
    Width = 5
    Height = 600
    ExplicitLeft = 224
    ExplicitTop = -6
    ExplicitHeight = 606
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 600
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lblPrompts: TLabel
      Left = 8
      Top = 8
      Width = 100
      Height = 15
      Caption = 'Prompt Templates:'
    end
    object lstPrompts: TListBox
      Left = 8
      Top = 29
      Width = 204
      Height = 523
      ItemHeight = 15
      TabOrder = 0
      OnClick = lstPromptsClick
    end
    object btnNew: TButton
      Left = 8
      Top = 558
      Width = 90
      Height = 30
      Caption = 'New'
      TabOrder = 1
      OnClick = btnNewClick
    end
    object btnDelete: TButton
      Left = 104
      Top = 558
      Width = 90
      Height = 30
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
  object pnlRight: TPanel
    Left = 225
    Top = 0
    Width = 675
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblName: TLabel
      Left = 8
      Top = 8
      Width = 78
      Height = 15
      Caption = 'Prompt Name:'
    end
    object lblCategory: TLabel
      Left = 8
      Top = 61
      Width = 52
      Height = 15
      Caption = 'Category:'
    end
    object lblDescription: TLabel
      Left = 8
      Top = 114
      Width = 66
      Height = 15
      Caption = 'Description:'
    end
    object lblTemplate: TLabel
      Left = 8
      Top = 214
      Width = 99
      Height = 15
      Caption = 'Prompt Template:'
    end
    object lblVariables: TLabel
      Left = 8
      Top = 414
      Width = 190
      Height = 15
      Caption = 'Variables (one per line, e.g. {topic}):'
    end
    object edtName: TEdit
      Left = 8
      Top = 29
      Width = 659
      Height = 23
      TabOrder = 0
    end
    object cmbCategory: TComboBox
      Left = 8
      Top = 82
      Width = 300
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = cmbCategoryChange
    end
    object memoDescription: TMemo
      Left = 8
      Top = 135
      Width = 659
      Height = 66
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object memoTemplate: TMemo
      Left = 8
      Top = 235
      Width = 659
      Height = 166
      ScrollBars = ssVertical
      TabOrder = 3
    end
    object memoVariables: TMemo
      Left = 8
      Top = 435
      Width = 659
      Height = 66
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object btnSave: TButton
      Left = 8
      Top = 507
      Width = 150
      Height = 32
      Caption = 'Save'
      TabOrder = 5
      OnClick = btnSaveClick
    end
    object btnApplyToChat: TButton
      Left = 164
      Top = 507
      Width = 150
      Height = 32
      Caption = 'Apply to Chat'
      TabOrder = 6
      OnClick = btnApplyToChatClick
    end
  end
end
