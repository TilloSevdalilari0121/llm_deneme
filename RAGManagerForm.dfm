object frmRAGManager: TfrmRAGManager
  Left = 0
  Top = 0
  Caption = 'RAG Document Manager'
  ClientHeight = 650
  ClientWidth = 900
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
    Width = 900
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblStatus: TLabel
      Left = 8
      Top = 54
      Width = 3
      Height = 15
    end
    object btnUpload: TButton
      Left = 8
      Top = 8
      Width = 150
      Height = 32
      Caption = 'Upload Document'
      TabOrder = 0
      OnClick = btnUploadClick
    end
    object btnDelete: TButton
      Left = 164
      Top = 8
      Width = 150
      Height = 32
      Caption = 'Delete Selected'
      TabOrder = 1
      OnClick = btnDeleteClick
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
    object progressUpload: TProgressBar
      Left = 480
      Top = 15
      Width = 412
      Height = 17
      TabOrder = 3
      Visible = False
    end
  end
  object pnlDocuments: TPanel
    Left = 0
    Top = 80
    Width = 900
    Height = 220
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblDocuments: TLabel
      Left = 8
      Top = 8
      Width = 126
      Height = 15
      Caption = 'Uploaded Documents:'
    end
    object lstDocuments: TListView
      Left = 8
      Top = 29
      Width = 884
      Height = 183
      Columns = <>
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object pnlQuery: TPanel
    Left = 0
    Top = 300
    Width = 900
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lblQuery: TLabel
      Left = 8
      Top = 8
      Width = 80
      Height = 15
      Caption = 'Search Query:'
    end
    object lblResults: TLabel
      Left = 8
      Top = 154
      Width = 84
      Height = 15
      Caption = 'Search Results:'
    end
    object memoQuery: TMemo
      Left = 8
      Top = 29
      Width = 884
      Height = 80
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object btnSearch: TButton
      Left = 8
      Top = 115
      Width = 200
      Height = 28
      Caption = 'Search Documents'
      TabOrder = 1
      OnClick = btnSearchClick
    end
    object memoResults: TRichEdit
      Left = 8
      Top = 175
      Width = 884
      Height = 167
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object OpenDialog: TOpenDialog
    Left = 824
    Top = 24
  end
end
