object frmPluginManager: TfrmPluginManager
  Left = 0
  Top = 0
  Caption = 'Plugin Manager'
  ClientHeight = 550
  ClientWidth = 800
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
    Width = 800
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblStatus: TLabel
      Left = 8
      Top = 48
      Width = 3
      Height = 15
    end
    object btnLoad: TButton
      Left = 8
      Top = 8
      Width = 150
      Height = 32
      Caption = 'Load Plugin...'
      TabOrder = 0
      OnClick = btnLoadClick
    end
    object btnUnload: TButton
      Left = 164
      Top = 8
      Width = 150
      Height = 32
      Caption = 'Unload Selected'
      TabOrder = 1
      OnClick = btnUnloadClick
    end
    object btnRefresh: TButton
      Left = 320
      Top = 8
      Width = 150
      Height = 32
      Caption = 'Refresh List'
      TabOrder = 2
      OnClick = btnRefreshClick
    end
  end
  object pnlPlugins: TPanel
    Left = 0
    Top = 80
    Width = 800
    Height = 470
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblPlugins: TLabel
      Left = 8
      Top = 8
      Width = 83
      Height = 15
      Caption = 'Loaded Plugins:'
    end
    object lblInfo: TLabel
      Left = 8
      Top = 248
      Width = 76
      Height = 15
      Caption = 'Plugin Details:'
    end
    object lstPlugins: TListView
      Left = 8
      Top = 29
      Width = 784
      Height = 200
      Columns = <>
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lstPluginsClick
    end
    object memoInfo: TMemo
      Left = 8
      Top = 269
      Width = 784
      Height = 193
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object OpenDialog: TOpenDialog
    Left = 728
    Top = 24
  end
end
