unit unit_globals;

interface
uses
  Vcl.Graphics, System.SysUtils, view.mensagens;
var
  gbLogado        : Boolean;
  gbServidorOk    : Boolean;
  gbCaixaAberto   : Boolean;
  gbTicketAberto  : Boolean;
  gsNomeUsuario   : string;
  gsProprietario  : string;
  gsPDV           : string;
  gsCaixa         : string;
  giIdUsuario     : Integer;
  gcFatorH        : Currency;
  gcFatorV        : Currency;
  gtfFormato      : TFormatSettings;

  msgMensagemGlobal: TfrmMensagem;



const
  CKey            :String  = '73e76eb2c5b5e306bb3f5f8e3ad808b6';
  CIV             :String  = '6694f38735f00910';
  CCorAberto      :TColor  = $00476300;
  CCorFechado     :TColor  = $003F3FBE;
  cCorZebra1      :TColor  = $00D6F4FE;
  cCorZebra2      :TColor  = $00E6E6E6;
  cCorCampoTotal  :TColor  = $00CDEBFF;

implementation

end.
