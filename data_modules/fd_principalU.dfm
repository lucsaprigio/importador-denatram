object dm_principal: Tdm_principal
  Height = 480
  Width = 640
  object fd_clientes: TFDQuery
    Connection = dm_denatram.fd_denatram
    SQL.Strings = (
      'SELECT * FROM DB_CLIENTES')
    Left = 24
    Top = 16
  end
  object fd_veiculos: TFDQuery
    Connection = dm_denatram.fd_denatram
    SQL.Strings = (
      'SELECT * FROM DB_VEICULOS')
    Left = 96
    Top = 16
  end
  object cds_clientes: TClientDataSet
    Aggregates = <>
    PacketRecords = 0
    Params = <>
    ProviderName = 'dsp_clientes'
    Left = 24
    Top = 192
    object cds_clientesCNPJ_EMPRESA: TStringField
      FieldName = 'CNPJ_EMPRESA'
      Required = True
      Size = 14
    end
    object cds_clientesCNPJ: TStringField
      FieldName = 'CNPJ'
      Size = 14
    end
    object cds_clientesRAZAO_SOCIAL: TStringField
      FieldName = 'RAZAO_SOCIAL'
      Size = 60
    end
    object cds_clientesCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Required = True
    end
    object cds_clientesCEP: TIntegerField
      FieldName = 'CEP'
    end
    object cds_clientesENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 60
    end
    object cds_clientesPESSOA: TStringField
      FieldName = 'PESSOA'
      Size = 1
    end
    object cds_clientesBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 35
    end
    object cds_clientesCOD_CIDADE: TIntegerField
      FieldName = 'COD_CIDADE'
    end
    object cds_clientesUF: TStringField
      FieldName = 'UF'
      Size = 2
    end
    object cds_clientesCELULAR: TStringField
      FieldName = 'CELULAR'
      Size = 11
    end
    object cds_clientesTELEFONE: TStringField
      FieldName = 'TELEFONE'
      Size = 11
    end
    object cds_clientesCPF: TStringField
      FieldName = 'CPF'
      Size = 11
    end
    object cds_clientesCOMPLEMENTO: TStringField
      FieldName = 'COMPLEMENTO'
      Size = 80
    end
    object cds_clientesEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object cds_clientesNOME_CIDADE: TStringField
      FieldName = 'NOME_CIDADE'
      Size = 35
    end
    object cds_clientesDTA_TRANS: TSQLTimeStampField
      FieldName = 'DTA_TRANS'
    end
    object cds_clientesSTATUS: TIntegerField
      FieldName = 'STATUS'
    end
  end
  object cds_veiculos: TClientDataSet
    Aggregates = <>
    PacketRecords = 0
    Params = <>
    ProviderName = 'dsp_veiculos'
    Left = 104
    Top = 192
    object cds_veiculosCNPJ_EMPRESA: TStringField
      FieldName = 'CNPJ_EMPRESA'
      Required = True
      Size = 14
    end
    object cds_veiculosCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Required = True
    end
    object cds_veiculosNOVO_VELHO: TStringField
      FieldName = 'NOVO_VELHO'
      Size = 1
    end
    object cds_veiculosCHASSI: TStringField
      FieldName = 'CHASSI'
    end
    object cds_veiculosANO_FAB: TIntegerField
      FieldName = 'ANO_FAB'
    end
    object cds_veiculosANO_MODELO: TIntegerField
      FieldName = 'ANO_MODELO'
    end
    object cds_veiculosPLACA: TStringField
      FieldName = 'PLACA'
      Size = 14
    end
    object cds_veiculosRENAVAM: TStringField
      FieldName = 'RENAVAM'
      Size = 14
    end
    object cds_veiculosDTA_TRANS: TSQLTimeStampField
      FieldName = 'DTA_TRANS'
    end
    object cds_veiculosSTATUS: TIntegerField
      FieldName = 'STATUS'
    end
    object cds_veiculosDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 45
    end
  end
  object dsp_clientes: TDataSetProvider
    DataSet = fd_clientes
    Left = 24
    Top = 96
  end
  object dsp_veiculos: TDataSetProvider
    DataSet = fd_veiculos
    Left = 104
    Top = 96
  end
end
