unit FDDenatramU;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  Tdm_denatram = class(TDataModule)
    fd_denatram: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm_denatram: Tdm_denatram;

implementation

uses
  Vcl.Dialogs;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure Tdm_denatram.DataModuleCreate(Sender: TObject);
begin
          try
            fd_denatram.Connected := False;
            fd_denatram.Params.Values['Database'] := 'speedautomac.ddns.net:/database/Servicos/denatran.fdb';
            fd_denatram.Params.Values['Protocol'] := 'local';
            fd_denatram.LoginPrompt := False;

            fd_denatram.Connected := True;
          except on E: Exception do
             ShowMessage('Ocorreu um erro ' + e.Message);
          end;
end;

end.
