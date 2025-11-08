object frmWorkspace: TfrmWorkspace
  Left = 0
  Top = 0
  Caption = 'Workspace Manager'
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
    Left = 280
    Top = 100
    Width = 5
    Height = 500
    ExplicitLeft = 256
    ExplicitTop = 112
    ExplicitHeight = 100
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 100
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblWorkspace: TLabel
      Left = 8
      Top = 8
      Width = 90
      Height = 15
      Caption = 'Workspace Path:'
    end
    object lblStatus: TLabel
      Left = 8
      Top = 77
      Width = 3
      Height = 15
    end
    object edtWorkspacePath: TEdit
      Left = 8
      Top = 29
      Width = 700
      Height = 23
      ReadOnly = True
      TabOrder = 0
    end
    object btnBrowse: TButton
      Left = 714
      Top = 29
      Width = 90
      Height = 23
      Caption = 'Browse...'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
    object btnRefresh: TButton
      Left = 810
      Top = 29
      Width = 82
      Height = 23
      Caption = 'Refresh'
      TabOrder = 2
      OnClick = btnRefreshClick
    end
    object btnNew: TButton
      Left = 8
      Top = 58
      Width = 90
      Height = 23
      Caption = 'New File'
      TabOrder = 3
      OnClick = btnNewClick
    end
    object btnDelete: TButton
      Left = 104
      Top = 58
      Width = 90
      Height = 23
      Caption = 'Delete File'
      TabOrder = 4
      OnClick = btnDeleteClick
    end
  end
  object pnlFiles: TPanel
    Left = 0
    Top = 100
    Width = 280
    Height = 500
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object lblFiles: TLabel
      Left = 8
      Top = 8
      Width = 28
      Height = 15
      Caption = 'Files:'
    end
    object treeFiles: TTreeView
      Left = 8
      Top = 29
      Width = 264
      Height = 463
      Indent = 19
      TabOrder = 0
      OnClick = treeFilesClick
    end
  end
  object pnlEditor: TPanel
    Left = 285
    Top = 100
    Width = 615
    Height = 500
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lblEditor: TLabel
      Left = 8
      Top = 8
      Width = 77
      Height = 15
      Caption = 'Editor (No file)'
    end
    object memoEditor: TMemo
      Left = 8
      Top = 29
      Width = 599
      Height = 431
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
    object btnSave: TButton
      Left = 8
      Top = 466
      Width = 150
      Height = 26
      Caption = 'Save File'
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object chkReadOnly: TCheckBox
      Left = 164
      Top = 468
      Width = 97
      Height = 17
      Caption = 'Read Only'
      TabOrder = 2
    end
  end
end
