object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 550
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pgcSettings: TPageControl
    Left = 0
    Top = 0
    Width = 650
    Height = 500
    ActivePage = tsInference
    Align = alClient
    TabOrder = 0
    object tsInference: TTabSheet
      Caption = 'Inference Parameters'
      object lblTemperature: TLabel
        Left = 20
        Top = 20
        Width = 130
        Height = 15
        Caption = 'Temperature (Creativity)'
      end
      object lblTempHelp: TLabel
        Left = 20
        Top = 90
        Width = 550
        Height = 30
        AutoSize = False
        Caption =
          'Controls randomness. Lower = more focused/deterministic (0.1), ' +
          'Higher = more creative/random (1.0). Default: 0.7'
        WordWrap = True
      end
      object lblTopP: TLabel
        Left = 20
        Top = 130
        Width = 125
        Height = 15
        Caption = 'Top P (Nucleus Sampling)'
      end
      object lblTopPHelp: TLabel
        Left = 20
        Top = 200
        Width = 550
        Height = 30
        AutoSize = False
        Caption =
          'Controls diversity via cumulative probability. Only considers to' +
          'kens with cumulative probability < p. Default: 0.9'
        WordWrap = True
      end
      object lblTopK: TLabel
        Left = 20
        Top = 240
        Width = 127
        Height = 15
        Caption = 'Top K (Token Limitation)'
      end
      object lblTopKHelp: TLabel
        Left = 20
        Top = 290
        Width = 550
        Height = 30
        AutoSize = False
        Caption =
          'Limits sampling to top K tokens. Lower = less variety, Higher =' +
          ' more variety. Default: 40'
        WordWrap = True
      end
      object lblMaxTokens: TLabel
        Left = 20
        Top = 330
        Width = 139
        Height = 15
        Caption = 'Max Tokens (Output Limit)'
      end
      object lblMaxTokensHelp: TLabel
        Left = 20
        Top = 380
        Width = 550
        Height = 30
        AutoSize = False
        Caption =
          'Maximum number of tokens to generate. Longer responses need hig' +
          'her values. Default: 2048'
        WordWrap = True
      end
      object lblContextSize: TLabel
        Left = 350
        Top = 330
        Width = 162
        Height = 15
        Caption = 'Context Size (Memory Window)'
      end
      object lblContextHelp: TLabel
        Left = 350
        Top = 380
        Width = 270
        Height = 30
        AutoSize = False
        Caption =
          'Total context window including prompt and output. Default: 4096' +
          ''
        WordWrap = True
      end
      object trackTemperature: TTrackBar
        Left = 20
        Top = 45
        Width = 500
        Height = 30
        Max = 200
        Min = 1
        Position = 70
        TabOrder = 0
        OnChange = trackTemperatureChange
      end
      object edtTemperature: TEdit
        Left = 530
        Top = 45
        Width = 80
        Height = 23
        ReadOnly = True
        TabOrder = 1
        Text = '0.70'
      end
      object trackTopP: TTrackBar
        Left = 20
        Top = 155
        Width = 500
        Height = 30
        Max = 100
        Min = 1
        Position = 90
        TabOrder = 2
        OnChange = trackTopPChange
      end
      object edtTopP: TEdit
        Left = 530
        Top = 155
        Width = 80
        Height = 23
        ReadOnly = True
        TabOrder = 3
        Text = '0.90'
      end
      object edtTopK: TEdit
        Left = 20
        Top = 260
        Width = 100
        Height = 23
        TabOrder = 4
        Text = '40'
      end
      object edtMaxTokens: TEdit
        Left = 20
        Top = 350
        Width = 100
        Height = 23
        TabOrder = 5
        Text = '2048'
      end
      object edtContextSize: TEdit
        Left = 350
        Top = 350
        Width = 100
        Height = 23
        TabOrder = 6
        Text = '4096'
      end
    end
    object tsGPU: TTabSheet
      Caption = 'GPU / Performance'
      ImageIndex = 1
      object lblGPULayers: TLabel
        Left = 20
        Top = 70
        Width = 141
        Height = 15
        Caption = 'GPU Layers (ROCm Offload)'
      end
      object lblGPULayersHelp: TLabel
        Left = 20
        Top = 120
        Width = 550
        Height = 45
        AutoSize = False
        Caption =
          'Number of model layers to offload to GPU. 0 = CPU only. Higher ' +
          '= more GPU usage (faster but needs VRAM). Use 32+ for 7B models' +
          ', 40+ for 13B models.'
        WordWrap = True
      end
      object lblMainGPU: TLabel
        Left = 20
        Top = 180
        Width = 117
        Height = 15
        Caption = 'Main GPU (ROCm ID)'
      end
      object lblThreads: TLabel
        Left = 20
        Top = 240
        Width = 108
        Height = 15
        Caption = 'CPU Threads (Count)'
      end
      object lblThreadsHelp: TLabel
        Left = 20
        Top = 290
        Width = 550
        Height = 30
        AutoSize = False
        Caption =
          'Number of CPU threads for inference. Use your CPU core count. D' +
          'efault: 8'
        WordWrap = True
      end
      object lblGPUInfo: TLabel
        Left = 20
        Top = 350
        Width = 550
        Height = 60
        AutoSize = False
        Caption =
          'ROCm GPU Info: This build uses ROCm for AMD GPU acceleration. M' +
          'ake sure you have ROCm installed and configured. Check AMD GPU ' +
          'compatibility at: https://rocm.docs.amd.com'
        Color = clInfoBk
        ParentColor = False
        Transparent = False
        WordWrap = True
      end
      object chkGPUOffload: TCheckBox
        Left = 20
        Top = 20
        Width = 200
        Height = 25
        Caption = 'Enable GPU Offload (ROCm)'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 0
        OnClick = chkGPUOffloadClick
      end
      object edtGPULayers: TEdit
        Left = 20
        Top = 90
        Width = 100
        Height = 23
        TabOrder = 1
        Text = '32'
      end
      object edtMainGPU: TEdit
        Left = 20
        Top = 200
        Width = 100
        Height = 23
        TabOrder = 2
        Text = '0'
      end
      object edtThreads: TEdit
        Left = 20
        Top = 260
        Width = 100
        Height = 23
        TabOrder = 3
        Text = '8'
      end
    end
    object tsModelPaths: TTabSheet
      Caption = 'Model Locations'
      ImageIndex = 2
      object lblOllama: TLabel
        Left = 20
        Top = 20
        Width = 140
        Height = 15
        Caption = 'Ollama Models Directory:'
      end
      object lblLMStudio: TLabel
        Left = 20
        Top = 80
        Width = 159
        Height = 15
        Caption = 'LM Studio Models Directory:'
      end
      object lblJan: TLabel
        Left = 20
        Top = 140
        Width = 123
        Height = 15
        Caption = 'Jan Models Directory:'
      end
      object lblCustom: TLabel
        Left = 20
        Top = 200
        Width = 152
        Height = 15
        Caption = 'Custom Models Directory:'
      end
      object edtOllamaPath: TEdit
        Left = 20
        Top = 40
        Width = 480
        Height = 23
        TabOrder = 0
      end
      object btnBrowseOllama: TButton
        Left = 510
        Top = 39
        Width = 100
        Height = 25
        Caption = 'Browse...'
        TabOrder = 1
        OnClick = btnBrowseOllamaClick
      end
      object edtLMStudioPath: TEdit
        Left = 20
        Top = 100
        Width = 480
        Height = 23
        TabOrder = 2
      end
      object btnBrowseLMStudio: TButton
        Left = 510
        Top = 99
        Width = 100
        Height = 25
        Caption = 'Browse...'
        TabOrder = 3
        OnClick = btnBrowseLMStudioClick
      end
      object edtJanPath: TEdit
        Left = 20
        Top = 160
        Width = 480
        Height = 23
        TabOrder = 4
      end
      object btnBrowseJan: TButton
        Left = 510
        Top = 159
        Width = 100
        Height = 25
        Caption = 'Browse...'
        TabOrder = 5
        OnClick = btnBrowseJanClick
      end
      object edtCustomPath: TEdit
        Left = 20
        Top = 220
        Width = 480
        Height = 23
        TabOrder = 6
      end
      object btnBrowseCustom: TButton
        Left = 510
        Top = 219
        Width = 100
        Height = 25
        Caption = 'Browse...'
        TabOrder = 7
        OnClick = btnBrowseCustomClick
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 500
    Width = 650
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      Left = 350
      Top = 10
      Width = 90
      Height = 30
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 450
      Top = 10
      Width = 90
      Height = 30
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnApply: TButton
      Left = 550
      Top = 10
      Width = 90
      Height = 30
      Caption = 'Apply'
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
end
