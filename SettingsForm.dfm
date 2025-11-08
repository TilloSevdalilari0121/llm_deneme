object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  Caption = 'Settings'
  ClientHeight = 500
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 700
    Height = 450
    ActivePage = tabGeneral
    Align = alClient
    TabOrder = 0
    object tabGeneral: TTabSheet
      Caption = 'General'
      object lblDefaultTemp: TLabel
        Left = 16
        Top = 16
        Width = 119
        Height = 15
        Caption = 'Default Temperature:'
      end
      object lblTempValue: TLabel
        Left = 600
        Top = 16
        Width = 28
        Height = 15
        Caption = '0.70'
      end
      object lblDefaultTopP: TLabel
        Left = 16
        Top = 86
        Width = 81
        Height = 15
        Caption = 'Default Top-P:'
      end
      object lblTopPValue: TLabel
        Left = 600
        Top = 86
        Width = 28
        Height = 15
        Caption = '0.90'
      end
      object lblMaxTokens: TLabel
        Left = 16
        Top = 156
        Width = 114
        Height = 15
        Caption = 'Default Max Tokens:'
      end
      object trackTemp: TTrackBar
        Left = 16
        Top = 37
        Width = 577
        Height = 40
        Max = 200
        Position = 70
        TabOrder = 0
        OnChange = trackTempChange
      end
      object trackTopP: TTrackBar
        Left = 16
        Top = 107
        Width = 577
        Height = 40
        Max = 100
        Position = 90
        TabOrder = 1
        OnChange = trackTopPChange
      end
      object edtMaxTokens: TEdit
        Left = 16
        Top = 177
        Width = 200
        Height = 23
        TabOrder = 2
        Text = '2048'
      end
      object chkAutoSave: TCheckBox
        Left = 16
        Top = 216
        Width = 300
        Height = 17
        Caption = 'Auto-save conversations'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object chkStreamResponse: TCheckBox
        Left = 16
        Top = 239
        Width = 300
        Height = 17
        Caption = 'Enable streaming responses'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
    end
    object tabAPI: TTabSheet
      Caption = 'API Endpoints'
      ImageIndex = 1
      object lblOllamaURL: TLabel
        Left = 16
        Top = 16
        Width = 65
        Height = 15
        Caption = 'Ollama URL:'
      end
      object lblLMStudioURL: TLabel
        Left = 16
        Top = 69
        Width = 88
        Height = 15
        Caption = 'LM Studio URL:'
      end
      object lblJanURL: TLabel
        Left = 16
        Top = 122
        Width = 48
        Height = 15
        Caption = 'Jan URL:'
      end
      object edtOllamaURL: TEdit
        Left = 16
        Top = 37
        Width = 500
        Height = 23
        TabOrder = 0
        Text = 'http://localhost:11434'
      end
      object edtLMStudioURL: TEdit
        Left = 16
        Top = 90
        Width = 500
        Height = 23
        TabOrder = 1
        Text = 'http://localhost:1234'
      end
      object edtJanURL: TEdit
        Left = 16
        Top = 143
        Width = 500
        Height = 23
        TabOrder = 2
        Text = 'http://localhost:1337'
      end
    end
    object tabAdvanced: TTabSheet
      Caption = 'Advanced'
      ImageIndex = 2
      object lblWorkspacePath: TLabel
        Left = 16
        Top = 16
        Width = 90
        Height = 15
        Caption = 'Workspace Path:'
      end
      object lblTimeout: TLabel
        Left = 16
        Top = 69
        Width = 125
        Height = 15
        Caption = 'Request Timeout (sec):'
      end
      object lblMaxHistory: TLabel
        Left = 16
        Top = 122
        Width = 138
        Height = 15
        Caption = 'Max Conversation History:'
      end
      object edtWorkspacePath: TEdit
        Left = 16
        Top = 37
        Width = 500
        Height = 23
        TabOrder = 0
      end
      object btnBrowseWorkspace: TButton
        Left = 522
        Top = 37
        Width = 75
        Height = 23
        Caption = 'Browse...'
        TabOrder = 1
        OnClick = btnBrowseWorkspaceClick
      end
      object edtTimeout: TEdit
        Left = 16
        Top = 90
        Width = 200
        Height = 23
        TabOrder = 2
        Text = '30'
      end
      object edtMaxHistory: TEdit
        Left = 16
        Top = 143
        Width = 200
        Height = 23
        TabOrder = 3
        Text = '100'
      end
      object chkDebugMode: TCheckBox
        Left = 16
        Top = 182
        Width = 200
        Height = 17
        Caption = 'Enable Debug Mode'
        TabOrder = 4
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 450
    Width = 700
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnSave: TButton
      Left = 16
      Top = 13
      Width = 120
      Height = 30
      Caption = 'Save'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 142
      Top = 13
      Width = 120
      Height = 30
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnApply: TButton
      Left = 268
      Top = 13
      Width = 120
      Height = 30
      Caption = 'Apply'
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
end
