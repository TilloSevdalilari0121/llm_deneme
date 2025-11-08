object frmChat: TfrmChat
  Left = 0
  Top = 0
  Caption = 'Chat'
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
    Left = 200
    Top = 0
    Width = 5
    Height = 600
    ExplicitLeft = 250
    ExplicitHeight = 561
  end
  object pnlSidebar: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 600
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object btnNewChat: TButton
      Left = 8
      Top = 8
      Width = 184
      Height = 32
      Caption = 'New Chat'
      TabOrder = 0
      OnClick = btnNewChatClick
    end
    object btnDeleteChat: TButton
      Left = 8
      Top = 46
      Width = 184
      Height = 32
      Caption = 'Delete Chat'
      TabOrder = 1
      OnClick = btnDeleteChatClick
    end
    object lstConversations: TListBox
      Left = 8
      Top = 84
      Width = 184
      Height = 508
      ItemHeight = 15
      TabOrder = 2
      OnClick = lstConversationsClick
    end
  end
  object pnlChat: TPanel
    Left = 205
    Top = 0
    Width = 495
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object memoChat: TRichEdit
      Left = 0
      Top = 0
      Width = 495
      Height = 470
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object pnlInput: TPanel
      Left = 0
      Top = 470
      Width = 495
      Height = 130
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object memoInput: TMemo
        Left = 0
        Top = 0
        Width = 495
        Height = 90
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object btnSend: TButton
        Left = 8
        Top = 96
        Width = 200
        Height = 28
        Caption = 'Send'
        TabOrder = 1
        OnClick = btnSendClick
      end
      object btnStop: TButton
        Left = 214
        Top = 96
        Width = 200
        Height = 28
        Caption = 'Stop'
        TabOrder = 2
        OnClick = btnStopClick
      end
    end
  end
  object pnlParams: TPanel
    Left = 700
    Top = 0
    Width = 200
    Height = 600
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object lblTemp: TLabel
      Left = 8
      Top = 8
      Width = 72
      Height = 15
      Caption = 'Temperature:'
    end
    object lblTempValue: TLabel
      Left = 160
      Top = 8
      Width = 28
      Height = 15
      Caption = '0.70'
    end
    object lblTopP: TLabel
      Left = 8
      Top = 78
      Width = 35
      Height = 15
      Caption = 'Top P:'
    end
    object lblTopPValue: TLabel
      Left = 160
      Top = 78
      Width = 28
      Height = 15
      Caption = '0.90'
    end
    object lblMaxTokens: TLabel
      Left = 8
      Top = 148
      Width = 68
      Height = 15
      Caption = 'Max Tokens:'
    end
    object trackTemp: TTrackBar
      Left = 8
      Top = 29
      Width = 184
      Height = 40
      Max = 200
      Position = 70
      TabOrder = 0
      OnChange = trackTempChange
    end
    object trackTopP: TTrackBar
      Left = 8
      Top = 99
      Width = 184
      Height = 40
      Max = 100
      Position = 90
      TabOrder = 1
      OnChange = trackTopPChange
    end
    object edtMaxTokens: TEdit
      Left = 8
      Top = 169
      Width = 184
      Height = 23
      TabOrder = 2
      Text = '2048'
    end
  end
end
