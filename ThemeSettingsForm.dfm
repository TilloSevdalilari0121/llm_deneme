object frmThemeSettings: TfrmThemeSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Theme Settings'
  ClientHeight = 450
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object rgMode: TRadioGroup
    Left = 20
    Top = 20
    Width = 460
    Height = 80
    Caption = ' Theme Mode '
    TabOrder = 0
    OnClick = rgModeClick
  end
  object rgColorScheme: TRadioGroup
    Left = 20
    Top = 110
    Width = 460
    Height = 150
    Caption = ' Color Scheme '
    TabOrder = 1
    OnClick = rgColorSchemeClick
  end
  object pnlPreview: TPanel
    Left = 20
    Top = 270
    Width = 460
    Height = 120
    BevelOuter = bvLowered
    TabOrder = 2
    object lblPreview: TLabel
      Left = 10
      Top = 10
      Width = 88
      Height = 15
      Caption = 'Theme Preview:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pnlPreviewBg: TPanel
      Left = 10
      Top = 35
      Width = 440
      Height = 75
      TabOrder = 0
      object lblPreviewText: TLabel
        Left = 10
        Top = 10
        Width = 420
        Height = 55
        AutoSize = False
        Caption =
          'This is a preview of the selected theme. Accent colors and text' +
          ' will look like this.'
        WordWrap = True
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 400
    Width = 500
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 399
    ExplicitWidth = 496
    object btnOK: TButton
      Left = 200
      Top = 10
      Width = 90
      Height = 30
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 300
      Top = 10
      Width = 90
      Height = 30
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnApply: TButton
      Left = 400
      Top = 10
      Width = 90
      Height = 30
      Caption = 'Apply'
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
end
