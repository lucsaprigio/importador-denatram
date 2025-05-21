unit denatramU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Horse, consultaClienteU;

type
  TfrmPrincipal = class(TForm)
    memHistorico: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure StartServer;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  App: THorse;


implementation

uses
  configU;

{$R *.dfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
    ConsultaCliente: TConsultaThread;
begin
          AppConfig  := TAppConfig.Create; // como se fosse usar um new AppConfig


          if AppConfig.ApiKey ='' then
          begin
             ShowMessage('Favor preencha a API_KEY no config.ini');

             TThread.Queue(nil,
             procedure
             begin
               Application.Terminate;
             end
             ) ;

              Exit;
          end;

          // Criando a Thread para inicialização separada do Aplicativo, para não travar a interface
          TThread.CreateAnonymousThread(
            procedure
            begin
              StartServer;
            end
          ).Start;

          memHistorico.Lines.Add('URL_RENAVE: '  + Appconfig.UrlRenave ) ;

          ConsultaCliente := TConsultaThread.Create(False);
          ConsultaCliente.FreeOnTerminate := True;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
           AppConfig.Free;
end;

procedure TfrmPrincipal.StartServer;
begin
    try
      App.Listen(9000);

      memHistorico.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) + 'Aplicação iniciada.');
    except on E: Exception do
      memHistorico.Lines.Add('Ocorreu um Erro: ' + E.Message);
    end;
end;

end.
