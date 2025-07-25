object frmAbrirCaixa: TfrmAbrirCaixa
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmAbrirCaixa'
  ClientHeight = 300
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  TextHeight = 15
  object shpAbrirCaixa: TShape
    Left = 0
    Top = 0
    Width = 800
    Height = 300
    Align = alClient
    Brush.Color = clMoneyGreen
    Pen.Color = 4678400
    Pen.Width = 5
    ExplicitTop = 8
  end
  object lblCaixa: TLabel
    Left = 204
    Top = 75
    Width = 72
    Height = 32
    Caption = 'Caixa*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblEntradaDnh: TLabel
    Left = 56
    Top = 131
    Width = 209
    Height = 32
    Caption = 'Entrada (dinheiro)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object pnlTopAbrirCaixa: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 40
    BevelOuter = bvNone
    Color = 4678400
    ParentBackground = False
    TabOrder = 0
    object lblTopAbrirCaixa: TLabel
      Left = 0
      Top = 0
      Width = 152
      Height = 32
      Align = alClient
      Alignment = taCenter
      Caption = 'ABRIR CAIXA'
      Color = 4678400
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
  end
  object pnlBotAbrir: TPanel
    Left = 604
    Top = 223
    Width = 157
    Height = 41
    BevelOuter = bvNone
    Color = clTeal
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMoneyGreen
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    TabStop = True
    OnEnter = pnlBotAbrirEnter
    OnExit = pnlBotAbrirExit
    object btnAbrirCaixa: TSpeedButton
      Left = 0
      Top = 0
      Width = 157
      Height = 41
      Cursor = crHandPoint
      Align = alClient
      Caption = 'ABRIR'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
      OnClick = btnAbrirCaixaClick
      ExplicitLeft = 55
      ExplicitTop = 21
      ExplicitWidth = 273
    end
  end
  object edtCaixa: TWWPEdit
    Tag = 5
    Left = 296
    Top = 72
    Width = 65
    Height = 40
    Alignment = taCenter
    BevelInner = bvNone
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    MaxLength = 1
    NumbersOnly = True
    ParentFont = False
    TabOrder = 1
    OnExit = edtCaixaExit
    MudarCor = 14087422
    SemMarcador = False
  end
  object edtEntradaDnh: TWWPMaskEdit
    Left = 296
    Top = 128
    Width = 146
    Height = 40
    Cursor = crArrow
    Alignment = taRightJustify
    BevelInner = bvNone
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    MaxLength = 10
    ParentBiDiMode = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    Text = '0,00'
    OnKeyPress = edtEntradaDnhKeyPress
    MudarCor = 14087422
    SemMarcador = False
  end
end
