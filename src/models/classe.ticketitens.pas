unit classe.ticketitens;

interface
uses
  FireDAC.Comp.Client,
  FireDAC.DApt,
  System.SysUtils,
  unit_funcoes,
  unit_globals,
  Vcl.Forms;

type
  TTicketItens = class

  private
    FMsgErro      : string;
    FConexao      : TFDConnection;

    FVlun         : Currency;
    FQtd          : Currency;
    FEspecial     : string;
    FCancelado    : string;
    FNumticket    : string;
    FDescesp      : string;
    FCodprod      : string;
    FPedidoem     : TDateTime;
    FDescun       : Currency;
    FData         : TDate;
    FCanceladoem  : TDateTime;

  public
    property Conexao      : TFDConnection read FConexao write FConexao;
    property MsgErro      : string read FMsgErro write FMsgErro;

    property data         : TDate read FData write FData;
    property numticket    : string read FNumticket write FNumticket;
    property codprod      : string read FCodprod write FCodprod;
    property qtd          : Currency read FQtd write FQtd;
    property vlun         : Currency read FVlun write FVlun;
    property descun       : Currency read FDescun write Fdescun;
    property especial     : string read FEspecial write FEspecial;
    property descesp      : string read FDescesp write FDescesp;
    property cancelado    : string read FCancelado write FCancelado;
    property pedidoem     : TDateTime read FPedidoem write FPedidoem;
    property canceladoem  : TDateTime read FCanceladoem write FCanceladoem;

    constructor Create(vConexao : TFDConnection);
    destructor Destroy; override;

    procedure prcAbrir;
    procedure prcFechar;
    procedure prcSQLInit;
    function fncPegaItensDoTicket(dData: TDate; sNumTicket: string): TFDQuery;

  end;
  var
    QryConsulta : TFDQuery;

implementation

{ TTicketItens }

constructor TTicketItens.Create(vConexao: TFDConnection);
begin
  FConexao := vConexao;
  QryConsulta := TFDQuery.Create(nil);
  QryConsulta.Connection := FConexao;
end;

destructor TTicketItens.Destroy;
begin
  QryConsulta.Destroy;
  inherited;
end;

procedure TTicketItens.prcAbrir;
begin
  try
    try
      FConexao.Connected := True;
    except on E: Exception do
      begin
        FMsgErro      := E.Message;
        gbServidorOk  := False;
      end;
    end;
  finally
    gbServidorOk := True;
  end;
end;

procedure TTicketItens.prcFechar;
begin
  FConexao.Connected := False;
  gbServidorOk := False;
end;

procedure TTicketItens.prcSQLInit;
begin
  QryConsulta.Close;
  QryConsulta.SQL.Clear;
end;

function TTicketItens.fncPegaItensDoTicket(dData: TDate; sNumTicket: string): TFDQuery;
begin
  try
    prcFechar;
    prcAbrir;

    prcSQLInit;

    QryConsulta.SQL.Add('SELECT * ');
    QryConsulta.SQL.Add('FROM ticketitens ');
    QryConsulta.SQL.Add('WHERE data = :pData AND ');
    QryConsulta.SQL.Add('numticket = :pNumticket ');
    QryConsulta.SQL.Add('ORDER BY codprod ASC');

    QryConsulta.ParamByName('pData').AsString := FormatDateTime('yyyy-mm-dd', dData);
    QryConsulta.ParamByName('pNumticket').AsString := sNumTicket;
    QryConsulta.Open;
  finally
    Result := QryConsulta;
  end;
end;

end.
