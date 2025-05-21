object dm_denatram: Tdm_denatram
  OnCreate = DataModuleCreate
  Height = 430
  Width = 640
  object fd_denatram: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'Port=3050'
      'CharacterSet=ISO8859_1'
      'Database=192.168.0.80:/database/Servicos/denatran.fdb'
      'DriverID=FB')
    Left = 32
    Top = 8
  end
end
