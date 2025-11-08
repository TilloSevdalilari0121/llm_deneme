object frmWorkspace: TfrmWorkspace
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Workspace Manager'
  ClientHeight = 500
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 100
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblWorkspace: TLabel
      Left = 20
      Top = 20
      Width = 97
      Height = 15
      Caption = 'Workspace Folder:'
    end
    object edtWorkspacePath: TEdit
      Left = 20
      Top = 40
      Width = 420
      Height = 23
      TabOrder = 0
    end
    object btnBrowse: TButton
      Left = 450
      Top = 39
      Width = 100
      Height = 25
      Caption = 'Browse...'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
    object btnSet: TButton
      Left = 20
      Top = 70
      Width = 100
      Height = 25
      Caption = 'Set Workspace'
      TabOrder = 2
      OnClick = btnSetClick
    end
    object btnRefresh: TButton
      Left = 130
      Top = 70
      Width = 100
      Height = 25
      Caption = 'Refresh'
      TabOrder = 3
      OnClick = btnRefreshClick
    end
  end
  object lstFiles: TListBox
    Left = 0
    Top = 100
    Width = 600
    Height = 340
    Align = alClient
    ItemHeight = 15
    TabOrder = 1
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 440
    Width = 600
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblInfo: TLabel
      Left = 20
      Top = 20
      Width = 99
      Height = 15
      Caption = 'No workspace set'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnClose: TButton
      Left = 480
      Top = 15
      Width = 100
      Height = 30
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
end
