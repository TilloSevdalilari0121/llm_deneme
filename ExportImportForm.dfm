object frmExportImport: TfrmExportImport
  Left = 0
  Top = 0
  Caption = 'Export / Import'
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
  object lblStatus: TLabel
    Left = 8
    Top = 523
    Width = 3
    Height = 15
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 515
    ActivePage = tabExport
    Align = alTop
    TabOrder = 0
    object tabExport: TTabSheet
      Caption = 'Export'
      object pnlExport: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 485
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblExportConv: TLabel
          Left = 8
          Top = 8
          Width = 79
          Height = 15
          Caption = 'Conversations:'
        end
        object lblExportPreview: TLabel
          Left = 8
          Top = 248
          Width = 87
          Height = 15
          Caption = 'Export Preview:'
        end
        object lstConversations: TListBox
          Left = 8
          Top = 29
          Width = 300
          Height = 170
          ItemHeight = 15
          TabOrder = 0
          OnClick = lstConversationsClick
        end
        object btnExportSelected: TButton
          Left = 8
          Top = 205
          Width = 140
          Height = 30
          Caption = 'Export Selected'
          TabOrder = 1
          OnClick = btnExportSelectedClick
        end
        object btnExportAll: TButton
          Left = 154
          Top = 205
          Width = 140
          Height = 30
          Caption = 'Export All'
          TabOrder = 2
          OnClick = btnExportAllClick
        end
        object btnRefresh: TButton
          Left = 320
          Top = 29
          Width = 140
          Height = 30
          Caption = 'Refresh'
          TabOrder = 3
          OnClick = btnRefreshClick
        end
        object memoExportPreview: TMemo
          Left = 8
          Top = 269
          Width = 776
          Height = 208
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 4
          WordWrap = False
        end
      end
    end
    object tabImport: TTabSheet
      Caption = 'Import'
      ImageIndex = 1
      object pnlImport: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 485
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblImportFile: TLabel
          Left = 8
          Top = 8
          Width = 57
          Height = 15
          Caption = 'JSON File:'
        end
        object lblImportPreview: TLabel
          Left = 8
          Top = 78
          Width = 89
          Height = 15
          Caption = 'Import Preview:'
        end
        object edtImportFile: TEdit
          Left = 8
          Top = 29
          Width = 600
          Height = 23
          ReadOnly = True
          TabOrder = 0
        end
        object btnBrowseImport: TButton
          Left = 614
          Top = 29
          Width = 90
          Height = 23
          Caption = 'Browse...'
          TabOrder = 1
          OnClick = btnBrowseImportClick
        end
        object btnImport: TButton
          Left = 710
          Top = 29
          Width = 74
          Height = 23
          Caption = 'Import'
          TabOrder = 2
          OnClick = btnImportClick
        end
        object memoImportPreview: TMemo
          Left = 8
          Top = 99
          Width = 776
          Height = 378
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 3
          WordWrap = False
        end
      end
    end
  end
  object SaveDialog: TSaveDialog
    Left = 712
    Top = 520
  end
  object OpenDialog: TOpenDialog
    Left = 752
    Top = 520
  end
end
