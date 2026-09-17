object frmPedido: TfrmPedido
  Left = 0
  Top = 0
  Caption = 'TecDelphi'
  ClientHeight = 532
  ClientWidth = 844
  Color = clBtnFace
  Constraints.MaxWidth = 860
  Constraints.MinWidth = 860
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object grpDadosPedido: TGroupBox
    Left = 0
    Top = 0
    Width = 844
    Height = 84
    Align = alTop
    Caption = 'Dados Pedido'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitTop = -6
    ExplicitWidth = 846
    object Label1: TLabel
      Left = 10
      Top = 26
      Width = 97
      Height = 17
      Caption = 'N'#250'mero Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 713
      Top = 26
      Width = 50
      Height = 17
      Caption = 'Emiss'#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtCodigo: TEdit
      Left = 10
      Top = 49
      Width = 120
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      NumbersOnly = True
      ParentFont = False
      TabOrder = 0
    end
    object DateTimePicker1: TDateTimePicker
      Left = 713
      Top = 49
      Width = 120
      Height = 25
      Date = 46282.000000000000000000
      Time = 0.687750949073233600
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object grpDadosCliente: TGroupBox
    Left = 0
    Top = 84
    Width = 844
    Height = 80
    Align = alTop
    Caption = 'Dados Cliente'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitTop = 80
    ExplicitWidth = 846
    object Label2: TLabel
      Left = 136
      Top = 25
      Width = 37
      Height = 17
      Caption = 'Nome'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 477
      Top = 26
      Width = 42
      Height = 17
      Caption = 'Cidade'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 783
      Top = 26
      Width = 16
      Height = 17
      Caption = 'UF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblClienteCod: TLabel
      Left = 10
      Top = 25
      Width = 44
      Height = 17
      Caption = 'C'#243'digo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtNome: TEdit
      Left = 136
      Top = 48
      Width = 335
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object edtCidade: TEdit
      Left = 477
      Top = 49
      Width = 300
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object edtUF: TEdit
      Left = 783
      Top = 49
      Width = 50
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object edtClienteCod: TEdit
      Left = 10
      Top = 48
      Width = 120
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 164
    Width = 844
    Height = 368
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    ExplicitTop = 163
    ExplicitWidth = 846
    ExplicitHeight = 45
    object pnlPedidoBotoes: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 834
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 136
      ExplicitTop = 56
      ExplicitWidth = 185
      object Button1: TButton
        Left = 727
        Top = 8
        Width = 104
        Height = 25
        Caption = 'Incluir'
        TabOrder = 0
      end
    end
    object grdPedidoItens: TDBGrid
      AlignWithMargins = True
      Left = 5
      Top = 52
      Width = 834
      Height = 311
      Align = alClient
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'codigo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ReadOnly = True
          Title.Caption = 'C'#243'd. Produto'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = []
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'descricao'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ReadOnly = True
          Title.Caption = 'Descri'#231#227'o'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = []
          Width = 315
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'quantidade'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          Title.Caption = 'Quantidade'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = []
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'vlr_unitario'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          Title.Caption = 'Vlr. Unit'#225'rio'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = []
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'vlr_total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          Title.Caption = 'Vlr. Total'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = []
          Width = 150
          Visible = True
        end>
    end
  end
end
