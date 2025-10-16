object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 150
  Width = 215
  object serverUDP: TIdUDPServer
    Bindings = <>
    DefaultPort = 0
    OnUDPRead = serverUDPUDPRead
    Left = 8
    Top = 8
  end
  object ClientUDP: TIdUDPClient
    Port = 0
    Left = 80
    Top = 16
  end
end
