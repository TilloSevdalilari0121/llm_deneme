object frmThemeManager: TfrmThemeManager
  Left = 0
  Top = 0
  Caption = 'Theme Manager'
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
  object Splitter1: TSplitter
    Left = 220
    Top = 0
    Width = 5
    Height = 500
    ExplicitLeft = 304
    ExplicitTop = 104
    ExplicitHeight = 100
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 500
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lblThemes: TLabel
      Left = 8
      Top = 8
      Width = 104
      Height = 15
      Caption = 'Available Themes:'
    end
    object lstThemes: TListBox
      Left = 8
      Top = 29
      Width = 204
      Height = 425
      ItemHeight = 15
      TabOrder = 0
      OnClick = lstThemesClick
    end
    object btnApply: TButton
      Left = 8
      Top = 460
      Width = 204
      Height = 32
      Caption = 'Apply Theme'
      TabOrder = 1
      OnClick = btnApplyClick
    end
  end
  object pnlRight: TPanel
    Left = 225
    Top = 0
    Width = 475
    Height = 500
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblPreview: TLabel
      Left = 8
      Top = 8
      Width = 85
      Height = 15
      Caption = 'Theme Preview:'
    end
    object lblColors: TLabel
      Left = 8
      Top = 308
      Width = 72
      Height = 15
      Caption = 'Color Palette:'
    end
    object lblBgColor: TLabel
      Left = 8
      Top = 337
      Width = 115
      Height = 15
      Caption = 'Background Color:'
    end
    object lblTextColor: TLabel
      Left = 8
      Top = 376
      Width = 60
      Height = 15
      Caption = 'Text Color:'
    end
    object lblAccentColor: TLabel
      Left = 8
      Top = 415
      Width = 73
      Height = 15
      Caption = 'Accent Color:'
    end
    object pnlPreview: TPanel
      Left = 8
      Top = 29
      Width = 459
      Height = 260
      BevelOuter = bvNone
      TabOrder = 0
      object pnlBackground: TPanel
        Left = 0
        Top = 0
        Width = 459
        Height = 260
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblSampleText: TLabel
          Left = 16
          Top = 16
          Width = 293
          Height = 32
          Caption = 'Sample Text in Theme'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblSampleAccent: TLabel
          Left = 16
          Top = 54
          Width = 305
          Height = 32
          Caption = 'Accent Text in Theme'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object pnlSurface: TPanel
          Left = 16
          Top = 104
          Width = 427
          Height = 140
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
    object edtBgColor: TEdit
      Left = 140
      Top = 334
      Width = 200
      Height = 23
      ReadOnly = True
      TabOrder = 1
    end
    object edtTextColor: TEdit
      Left = 140
      Top = 373
      Width = 200
      Height = 23
      ReadOnly = True
      TabOrder = 2
    end
    object edtAccentColor: TEdit
      Left = 140
      Top = 412
      Width = 200
      Height = 23
      ReadOnly = True
      TabOrder = 3
    end
  end
end
