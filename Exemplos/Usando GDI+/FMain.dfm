object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Usando GDI+'
  ClientHeight = 672
  ClientWidth = 1029
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object Splitter: TSplitter
    Left = 400
    Top = 0
    Height = 672
    ExplicitLeft = 284
    ExplicitTop = 36
    ExplicitHeight = 100
  end
  object TreeViewDemos: TTreeView
    Left = 0
    Top = 0
    Width = 400
    Height = 672
    Align = alLeft
    HideSelection = False
    Indent = 19
    ReadOnly = True
    TabOrder = 0
    OnChange = TreeViewDemosChange
  end
  object PanelClient: TPanel
    Left = 403
    Top = 0
    Width = 626
    Height = 672
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object SplitterRight: TSplitter
      Left = 0
      Top = 357
      Width = 626
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 0
      ExplicitWidth = 424
    end
    object Pages: TPageControl
      Left = 0
      Top = 0
      Width = 626
      Height = 357
      ActivePage = TabSheetText
      Align = alClient
      TabOrder = 0
      object TabSheetGraphic: TTabSheet
        Caption = 'Grafico'
        object PaintBox: TPaintBox
          Left = 15
          Top = 15
          Width = 603
          Height = 314
          Align = alClient
          OnPaint = PaintBoxPaint
          ExplicitLeft = 188
          ExplicitTop = 148
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
        object PaintBoxTopRuler: TPaintBox
          Left = 0
          Top = 0
          Width = 618
          Height = 15
          Align = alTop
          OnPaint = PaintBoxTopRulerPaint
          ExplicitWidth = 689
        end
        object PaintBoxLeftRuler: TPaintBox
          Left = 0
          Top = 15
          Width = 15
          Height = 314
          Align = alLeft
          OnPaint = PaintBoxLeftRulerPaint
          ExplicitTop = 16
          ExplicitHeight = 628
        end
      end
      object TabSheetText: TTabSheet
        Caption = 'Texto'
        ImageIndex = 1
        object Memo: TMemo
          Left = 0
          Top = 0
          Width = 618
          Height = 329
          Align = alClient
          BorderStyle = bsNone
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitLeft = -1
          ExplicitTop = -1
        end
      end
      object TabSheetPrint: TTabSheet
        Caption = 'Impressora'
        ImageIndex = 2
        object ButtonPrint: TButton
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Imprimir'
          TabOrder = 0
          OnClick = ButtonPrintClick
        end
      end
    end
    object RichEdit: TRichEdit
      Left = 0
      Top = 360
      Width = 626
      Height = 312
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      BevelKind = bkSoft
      BorderWidth = 5
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object PrintDialog: TPrintDialog
    Left = 424
    Top = 32
  end
end
