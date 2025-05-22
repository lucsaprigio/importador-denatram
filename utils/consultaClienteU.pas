unit consultaClienteU;

interface

uses System.SysUtils, System.Variants, System.Classes, FireDAC.Comp.Client,
     FireDAC.Stan.Param, System.JSON, Data.DB, FireDAC.DApt, REST.Json,
     System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TConsultaThread = class(TThread)
  protected
    procedure Execute; override;
    procedure AtualizarStatus(cnpj: string);
  end;

implementation

uses
  Vcl.Dialogs, denatranU, fd_principalU, FDDenatramU, configU,
  System.Net.URLClient;

{ TAgendadorThread }

procedure TConsultaThread.AtualizarStatus(cnpj: string);
var
  QryAtualizaCliente: TFDQuery;
begin
        QryAtualizaCliente := TFDQuery.Create(nil);
        QryAtualizaCliente.Connection := dm_denatram.fd_denatram;

        try
          QryAtualizaCliente.SQL.Clear;

          QryAtualizaCliente.SQL.Text   := 'UPDATE DB_CLIENTES SET STATUS = 1 WHERE CNPJ_EMPRESA = :cnpj';
          QryAtualizacliente.ParamByName('cnpj').AsString := cnpj;

          QryAtualizaCliente.ExecSQL; // Utilizar o Exec quando não retornar resultados como INSERT, DELETE E UPDATE

          QryAtualizaCliente.Connection.Commit;
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

        QryAtualizaCliente.Free;
end;

procedure TConsultaThread.Execute;
var
  Qry: TFDQuery;
  Con: TFDConnection;
  Obj: TJSONObject;
  JSONArr: TJSONArray;
  DadosEndereco, numero: String;
  PartesEndereco: TArray<string>;
  Http: THTTPClient;
  Response: IHTTPResponse;
  Content: TStringStream;
  i: Integer;
  cnpj_empresa: String;
  pessoa: string;
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
              'CNPJ, RAZAO_SOCIAL, CODIGO, CEP, ENDERECO, PESSOA,' +
              'BAIRRO, UF, CELULAR, CPF, TELEFONE, NOME_CIDADE, COMPLEMENTO from db_clientes WHERE STATUS = 0';
        Qry.Open;   // Utilizar o Open quando for retornar resultados

        TThread.Synchronize(nil,
          procedure
          begin
            frmPrincipal.memHistorico.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) + 'Consultando clientes');
          end
        );

        while not Qry.Eof do
        begin
            Obj := TJSONObject.Create;

            DadosEndereco  := Qry.FieldByName('ENDERECO').AsString;
            PartesEndereco := DadosEndereco.Split([',']);

          if Length(PartesEndereco) > 1 then
            numero := Trim(PartesEndereco[1])
          else
            numero := '0';

            if ( Qry.FieldByName('PESSOA').AsString = 'J') then
            begin
               pessoa := Qry.FieldByName('CNPJ').AsString;
            end
            else begin
               pessoa := Qry.FieldByName('CPF').AsString;
            end;

            Obj.AddPair('cnpj_empresa', Qry.FieldByName('CNPJ_EMPRESA').AsString);
            Obj.AddPair('id', pessoa);
            Obj.AddPair('tipoPessoa', Qry.FieldByName('PESSOA').AsString);
            Obj.AddPair('razaoSocial', Qry.FieldByName('RAZAO_SOCIAL').AsString);
            Obj.AddPair('cep', Qry.FieldByName('CEP').AsString);
            Obj.AddPair('logradouro', Qry.FieldByName('ENDERECO').AsString);
            Obj.AddPair('numero', numero);
            Obj.AddPair('bairro', Qry.FieldByName('BAIRRO').AsString);
            Obj.AddPair('cidade', Qry.FieldByName('NOME_CIDADE').AsString);
            Obj.AddPair('uf', Qry.FieldByName('PESSOA').AsString);

            JSONArr.AddElement(Obj);
            Qry.Next;
        end;

        for I := 0 to JSONArr.Count - 1 do
        begin
          Obj := JSONArr.Items[i] as TJSONObject;

          cnpj_empresa := Obj.GetValue<string>('cnpj_empresa');

          url := (AppConfig.UrlRenave + cnpj_empresa + '/client');



          Content := TStringStream.Create(Obj.ToJSON, TEncoding.UTF8);

          try
             Content.Position := 0;

             Http.CustomHeaders['Authorization'] := 'Bearer ' + AppConfig.ApiKey;
             Http.CustomHeaders['Content-Type'] := 'application/json';

             Obj.RemovePair('cnpj_empresa');

             Response := Http.Post(url, Content);

             if Response.StatusCode = 200 then
               begin
                 AtualizarStatus(cnpj_empresa);

                 TThread.Synchronize(nil,
                  procedure
                  begin
                    frmPrincipal.memHistorico.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) +
                    ' - [Cliente] - ' + Response.StatusCode.ToString +
                    ' - ' + Response.ContentAsString(TEncoding.UTF8));
                  end
                );
               end
               else begin
               TThread.Synchronize(nil,
                  procedure
                  begin
                    frmPrincipal.memHistorico.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) +
                    ' - [Cliente] - ' + Response.StatusCode.ToString +
                    ' - ' + Response.ContentAsString(TEncoding.UTF8));
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
        Con.Free;
        Qry.Free;
        Http.Free;

        Sleep(1000 * 60 * 60);
    end;

  end;
end.
