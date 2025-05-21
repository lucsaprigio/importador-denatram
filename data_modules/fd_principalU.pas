unit fd_principalU;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDDenatramU, Datasnap.Provider,
  Datasnap.DBClient;

type
  Tdm_principal = class(TDataModule)
    fd_clientes: TFDQuery;
    fd_veiculos: TFDQuery;
    cds_clientes: TClientDataSet;
    cds_veiculos: TClientDataSet;
    dsp_clientes: TDataSetProvider;
    cds_clientesCNPJ_EMPRESA: TStringField;
    cds_clientesCNPJ: TStringField;
    cds_clientesRAZAO_SOCIAL: TStringField;
    cds_clientesCODIGO: TIntegerField;
    cds_clientesCEP: TIntegerField;
    cds_clientesENDERECO: TStringField;
    cds_clientesPESSOA: TStringField;
    cds_clientesBAIRRO: TStringField;
    cds_clientesCOD_CIDADE: TIntegerField;
    cds_clientesUF: TStringField;
    cds_clientesCELULAR: TStringField;
    cds_clientesTELEFONE: TStringField;
    cds_clientesCPF: TStringField;
    cds_clientesCOMPLEMENTO: TStringField;
    cds_clientesEMAIL: TStringField;
    cds_clientesNOME_CIDADE: TStringField;
    cds_clientesDTA_TRANS: TSQLTimeStampField;
    cds_clientesSTATUS: TIntegerField;
    dsp_veiculos: TDataSetProvider;
    cds_veiculosCNPJ_EMPRESA: TStringField;
    cds_veiculosCODIGO: TIntegerField;
    cds_veiculosNOVO_VELHO: TStringField;
    cds_veiculosCHASSI: TStringField;
    cds_veiculosANO_FAB: TIntegerField;
    cds_veiculosANO_MODELO: TIntegerField;
    cds_veiculosPLACA: TStringField;
    cds_veiculosRENAVAM: TStringField;
    cds_veiculosDTA_TRANS: TSQLTimeStampField;
    cds_veiculosSTATUS: TIntegerField;
    cds_veiculosDESCRICAO: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm_principal: Tdm_principal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
