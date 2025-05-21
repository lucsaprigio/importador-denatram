program ImportadorDenatram;

uses
  Vcl.Forms,
  denatramU in 'denatramU.pas' {frmPrincipal},
  consultaClienteU in 'utils\consultaClienteU.pas',
  FDDenatramU in 'data_modules\FDDenatramU.pas' {dm_denatram: TDataModule},
  fd_principalU in 'data_modules\fd_principalU.pas' {dm_principal: TDataModule},
  configU in 'utils\configU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tdm_denatram, dm_denatram);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(Tdm_principal, dm_principal);
  Application.Run;
end.
