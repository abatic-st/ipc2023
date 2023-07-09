object FClient: TFClient
  Left = 0
  Top = 0
  Caption = 'Client'
  ClientHeight = 374
  ClientWidth = 727
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object lbHeader: TLabel
    Left = 241
    Top = -3
    Width = 134
    Height = 33
    Caption = 'TCP Client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
  end
  object lbMsgSend: TLabel
    Left = 8
    Top = 51
    Width = 154
    Height = 22
    Caption = 'Message to send'
    Color = clBtnShadow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -19
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object memoLog: TMemo
    Left = 8
    Top = 176
    Width = 709
    Height = 182
    BorderStyle = bsNone
    Color = clBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -17
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 0
  end
  object btnConnection: TButton
    Left = 8
    Top = 127
    Width = 265
    Height = 33
    Cursor = crHandPoint
    Caption = 'Connect to localhost server'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInactiveCaption
    Font.Height = -17
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnConnectionClick
  end
  object btnSender: TButton
    Left = 563
    Top = 127
    Width = 154
    Height = 33
    Cursor = crHandPoint
    Caption = 'Send Message'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInactiveCaption
    Font.Height = -17
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnSenderClick
  end
  object messageToSend: TMemo
    Left = 8
    Top = 76
    Width = 709
    Height = 45
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -17
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 3
  end
  object btnDisconnect: TButton
    Left = 287
    Top = 127
    Width = 137
    Height = 33
    Cursor = crHandPoint
    Caption = 'Disconnect'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInactiveCaption
    Font.Height = -17
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnDisconnectClick
  end
  object IdTCPClient: TIdTCPClient
    OnDisconnected = btnDisconnectClick
    OnConnected = IdTCPClientConnected
    ConnectTimeout = 0
    Host = 'localhost'
    Port = 20010
    ReadTimeout = -1
    Left = 632
    Top = 16
  end
  object IdThreadComponent: TIdThreadComponent
    Active = False
    Loop = False
    Priority = tpNormal
    StopMode = smTerminate
    OnRun = IdThreadComponentRun
    Left = 512
    Top = 16
  end
end
