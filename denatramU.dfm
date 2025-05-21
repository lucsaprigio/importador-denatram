object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Importador Denatram'
  ClientHeight = 388
  ClientWidth = 675
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object memHistorico: TMemo
    Left = 0
    Top = 8
    Width = 667
    Height = 377
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
