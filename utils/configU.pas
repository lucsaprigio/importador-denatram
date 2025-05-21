unit configU;

interface

uses
  System.SysUtils, System.IniFiles;

type
  TAppConfig = class     // Criando a classe
    private
      FApiKey: string;   // Método da Classe -> no caso aqui é a APIKey o F é a convenção para método privado de Field
      FUrlRenave: string;
      procedure CarregarConfiguracoes; // Médoto privado da classe
    public
      property ApiKey: string read FApiKey;
      property UrlRenave: string read FUrlRenave;
      constructor Create; // Quando for chamar o .Create()
  end;

var
  AppConfig: TAppConfig;

implementation

uses
  Vcl.Forms;

{ TAppConfig }


constructor TAppConfig.Create; // Aqui já estamos instanciando o .Create, para dizer que quando chamarmos no outro arquivo, ele já ultilizar essa procedure
begin
  CarregarConfiguracoes;
end;

procedure TAppConfig.CarregarConfiguracoes;
var
  ini: TIniFile;
  iniPath: String;
begin
    iniPath := ExtractFilePath(Application.ExeName) + 'config.ini';
    ini     := TIniFile.Create(iniPath);

  try
   if FileExists(iniPath) then begin
      FApiKey := ini.ReadString('RENAVE', 'API_KEY', '');
      FUrlRenave := ini.ReadString('RENAVE', 'URL_RENAVE', '');
   end
   else begin
     ini := TIniFile.Create(iniPath);
       ini.WriteString('RENAVE','API_KEY', '');
       ini.WriteString('RENAVE', 'URL_RENAVE', '');
   end;
  finally
      ini.Free;
  end;

end;


end.
