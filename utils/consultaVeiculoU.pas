unit consultaVeiculoU;

interface

uses System.SysUtils, System.Variants, System.Classes, FireDAC.Comp.Client,
     FireDAC.Stan.Param, System.JSON, Data.DB, FireDAC.DApt, REST.Json,
     System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TConsultaVeiculoThread = class(TThread)
  protected
    procedure Execute; override;
    procedure AtualizarStatusVeiculo(cnpj: string);
  end;

implementation

uses
  Vcl.Dialogs, denatranU, fd_principalU, FDDenatramU, configU,
  System.Net.URLClient;


{ TConsultaVeiculoThread }

procedure TConsultaVeiculoThread.AtualizarStatusVeiculo(cnpj: string);
var
  QryAtualizarVeiculo: TFDQuery;
begin
        QryAtualizarVeiculo := TFDQuery.Create(nil);
        QryAtualizarVeiculo.Connection := dm_denatram.fd_denatram;

        try
          QryAtualizarVeiculo.SQL.Clear;

          QryAtualizarVeiculo.SQL.Text   := 'UPDATE DB_VEICULOS SET STATUS = 1 WHERE CNPJ_EMPRESA = :cnpj';
          QryAtualizarVeiculo.ParamByName('cnpj').AsString := cnpj;

          QryAtualizarVeiculo.ExecSQL; // Utilizar o Exec quando não retornar resultados como INSERT, DELETE E UPDATE

          QryAtualizarVeiculo.Connection.Commit;
        except on E: Exception do
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              frmPrincipal.memHistorico.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) + E.Message);
            end
          );
          end;
        end;

        QryAtualizarVeiculo.Free;
end;

procedure TConsultaVeiculoThread.Execute;
var
  Qry: TFDQuery;
  Con: TFDConnection;
  Obj: TJSONObject;
  JSONArr: TJSONArray;
  Http: THTTPClient;
  Response: IHTTPResponse;
  Content: TStringStream;
  i: Integer;
  cnpj_empresa: String;
  url: string;
begin
  inherited;
   AppConfig  := TAppConfig.Create;

   while not Terminated do
    begin
      Qry      := TFDQuery.Create(nil);
      Con      := TFDConnection.Create(nil);
      JSONArr := TJSONArray.Create;
      Http := THTTPClient.Create;

      try
        Con.Params.Assign(dm_denatram.fd_denatram.Params);
        Con.LoginPrompt := False;
        Con.Connected := True;

        Qry.Connection := Con;
        Qry.SQL.Text   := 'select CNPJ_EMPRESA, ' +
            'CODIGO, NOVO_VELHO, COALESCE(DESCRICAO, ''SEM DESCRICAO'') AS DESCRICAO, CHASSI, ANO_FAB, ANO_MODELO, PLACA, RENAVAM, STATUS ' +
            'from DB_VEICULOS WHERE STATUS = 0';
        Qry.Open;   // Utilizar o Open quando for retornar resultados

        TThread.Synchronize(nil,
          procedure
          begin
            frmPrincipal.memHistorico.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) + 'Consultando Veículos');
          end
        );

        while not Qry.Eof do
        begin
            Obj := TJSONObject.Create;

            Obj.AddPair('cnpj_empresa', Qry.FieldByName('CNPJ_EMPRESA').AsString);
            Obj.AddPair('tipoVeiculo', Qry.FieldByName('NOVO_VELHO').AsString);
            Obj.AddPair('chassi', Qry.FieldByName('CHASSI').AsString);
            Obj.AddPair('descricao', Qry.FieldByName('DESCRICAO').AsString);
            Obj.AddPair('anoFabricacao', Qry.FieldByName('ANO_FAB').AsInteger);
            Obj.AddPair('anoModelo', Qry.FieldByName('ANO_MODELO').AsInteger);
            Obj.AddPair('placa', Qry.FieldByName('PLACA').AsString);
            Obj.AddPair('renavam', Qry.FieldByName('RENAVAM').AsString);

            JSONArr.AddElement(Obj);
            Qry.Next;
        end;

        for I := 0 to JSONArr.Count - 1 do
        begin
          Obj := JSONArr.Items[i] as TJSONObject;

          cnpj_empresa := Obj.GetValue<string>('cnpj_empresa');

          url := (AppConfig.UrlRenave + cnpj_empresa + '/vehicle');

          Content := TStringStream.Create(Obj.ToJSON, TEncoding.UTF8);

          try
             Content.Position := 0; // Para garamtir que todas as informãções do StringStream, vão para a requisição

             Http.CustomHeaders['Authorization'] := 'Bearer ' + AppConfig.ApiKey;
             Http.CustomHeaders['Content-Type'] := 'application/json';

             Obj.RemovePair('cnpj_empresa');

             Response := Http.Post(url, Content);

             if Response.StatusCode = 200 then
               begin
                 AtualizarStatusVeiculo(cnpj_empresa);

                 TThread.Synchronize(nil,
                  procedure
                  begin
                    frmPrincipal.memHistorico.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) +
                    ' - [Veículo] - ' +
                    ' - ' + Response.StatusCode.ToString + Response.ContentAsString(TEncoding.UTF8));
                  end
                );
               end
               else begin
               TThread.Synchronize(nil,
                  procedure
                  begin
                    frmPrincipal.memHistorico.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) +
                    ' - [Veículo] - ' +
                    ' - ' + Response.StatusCode.ToString + Response.ContentAsString(TEncoding.UTF8));
                  end
                );
               end;
          finally
            Content.Free;
          end;

        Sleep(5000);
        end;

      except
          on E: Exception do
            TThread.Synchronize(nil,
              procedure
              begin
                frmPrincipal.memHistorico.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) + E.Message);
              end
            );
       end;
        JSONArr.Free;
        Qry.Free;
        Http.Free;

        Sleep(1000 * 60 * 60);
    end;
end;

end.
