object frmFirstRunWizard: TfrmFirstRunWizard
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Local Model Runner - Setup Wizard'
  ClientHeight = 500
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pgcWizard: TPageControl
    Left = 0
    Top = 0
    Width = 700
    Height = 450
    ActivePage = tsWelcome
    Align = alClient
    TabOrder = 0
    OnChange = pgcWizardChange
    object tsWelcome: TTabSheet
      Caption = 'Welcome'
      object lblWelcome: TLabel
        Left = 20
        Top = 20
        Width = 330
        Height = 28
        Caption = 'Welcome to Local Model Runner!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object memoWelcome: TMemo
        Left = 20
        Top = 70
        Width = 650
        Height = 320
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          'This wizard will help you set up Local Model Runner for the first time.'
          ''
          'Features:'
          '- Run local LLM models directly (GGUF format)'
          '- ROCm GPU acceleration support'
          '- No API keys or internet required'
          '- Compatible with Ollama, LM Studio, and Jan models'
          '- Built-in code assistant for workspace editing'
          '- Multiple theme options'
          '- Conversation history management'
          ''
          'Click Next to continue setup.')
        ReadOnly = True
        TabOrder = 0
      end
    end
    object tsModelPaths: TTabSheet
      Caption = 'Model Paths'
      ImageIndex = 1
      object lblModelPathsInfo: TLabel
        Left = 20
        Top = 20
        Width = 650
        Height = 45
        AutoSize = False
        Caption =
          'Configure paths to existing model collections (optional). You c' +
          'an skip this and add models manually later.'
        WordWrap = True
      end
      object lblOllama: TLabel
        Left = 20
        Top = 80
        Width = 140
        Height = 15
        Caption = 'Ollama Models Directory:'
      end
      object lblLMStudio: TLabel
        Left = 20
        Top = 140
        Width = 159
        Height = 15
        Caption = 'LM Studio Models Directory:'
      end
      object lblJan: TLabel
        Left = 20
        Top = 200
        Width = 123
        Height = 15
        Caption = 'Jan Models Directory:'
      end
      object lblCustom: TLabel
        Left = 20
        Top = 260
        Width = 152
        Height = 15
        Caption = 'Custom Models Directory:'
      end
      object edtOllamaPath: TEdit
        Left = 20
        Top = 100
        Width = 530
        Height = 23
        TabOrder = 0
      end
      object btnBrowseOllama: TButton
        Left = 560
        Top = 99
        Width = 100
        Height = 25
        Caption = 'Browse...'
        TabOrder = 1
        OnClick = btnBrowseOllamaClick
      end
      object edtLMStudioPath: TEdit
        Left = 20
        Top = 160
        Width = 530
        Height = 23
        TabOrder = 2
      end
      object btnBrowseLMStudio: TButton
        Left = 560
        Top = 159
        Width = 100
        Height = 25
        Caption = 'Browse...'
        TabOrder = 3
        OnClick = btnBrowseLMStudioClick
      end
      object edtJanPath: TEdit
        Left = 20
        Top = 220
        Width = 530
        Height = 23
        TabOrder = 4
      end
      object btnBrowseJan: TButton
        Left = 560
        Top = 219
        Width = 100
        Height = 25
        Caption = 'Browse...'
        TabOrder = 5
        OnClick = btnBrowseJanClick
      end
      object edtCustomPath: TEdit
        Left = 20
        Top = 280
        Width = 530
        Height = 23
        TabOrder = 6
      end
      object btnBrowseCustom: TButton
        Left = 560
        Top = 279
        Width = 100
        Height = 25
        Caption = 'Browse...'
        TabOrder = 7
        OnClick = btnBrowseCustomClick
      end
    end
    object tsGPU: TTabSheet
      Caption = 'GPU Settings'
      ImageIndex = 2
      object lblGPUInfo: TLabel
        Left = 20
        Top = 20
        Width = 650
        Height = 60
        AutoSize = False
        Caption =
          'Configure GPU acceleration settings. ROCm must be installed for' +
          ' AMD GPU support. If you don'#39't have a compatible GPU or ROCm in' +
          'stalled, disable GPU offload to use CPU only.'
        WordWrap = True
      end
      object lblGPULayers: TLabel
        Left = 20
        Top = 130
        Width = 141
        Height = 15
        Caption = 'GPU Layers (ROCm Offload)'
      end
      object lblThreads: TLabel
        Left = 20
        Top = 190
        Width = 108
        Height = 15
        Caption = 'CPU Threads (Count)'
      end
      object chkGPUOffload: TCheckBox
        Left = 20
        Top = 90
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
        Top = 150
        Width = 100
        Height = 23
        TabOrder = 1
        Text = '32'
      end
      object edtThreads: TEdit
        Left = 20
        Top = 210
        Width = 100
        Height = 23
        TabOrder = 2
        Text = '8'
      end
    end
    object tsComplete: TTabSheet
      Caption = 'Complete'
      ImageIndex = 3
      object lblComplete: TLabel
        Left = 20
        Top = 20
        Width = 173
        Height = 28
        Caption = 'Setup Complete!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object memoComplete: TMemo
        Left = 20
        Top = 70
        Width = 650
        Height = 320
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          'Local Model Runner is now configured!'
          ''
          'Next steps:'
          '1. Add models via the Models Manager'
          '2. Load a model from the dropdown'
          '3. Start chatting!'
          ''
          'Tips:'
          '- Use Ctrl+Enter in the input box to send messages'
          '- Enable Code Mode to use /code commands for workspace editing'
          '- Access Settings to fine-tune inference parameters'
          '- Customize themes from the Theme button'
          ''
          'Click Finish to start using Local Model Runner!')
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 450
    Width = 700
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 449
    ExplicitWidth = 696
    object btnNext: TButton
      Left = 480
      Top = 10
      Width = 90
      Height = 30
      Caption = 'Next >'
      TabOrder = 0
      OnClick = btnNextClick
    end
    object btnBack: TButton
      Left = 380
      Top = 10
      Width = 90
      Height = 30
      Caption = '< Back'
      TabOrder = 1
      OnClick = btnBackClick
    end
    object btnFinish: TButton
      Left = 580
      Top = 10
      Width = 90
      Height = 30
      Caption = 'Finish'
      Default = True
      TabOrder = 2
      Visible = False
      OnClick = btnFinishClick
    end
    object btnCancel: TButton
      Left = 20
      Top = 10
      Width = 90
      Height = 30
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = btnCancelClick
    end
  end
end
