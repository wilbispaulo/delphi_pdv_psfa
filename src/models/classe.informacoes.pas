unit classe.informacoes;

interface
uses
  FireDAC.Comp.Client,
  FireDAC.DApt,
  System.SysUtils,
  unit_funcoes,
  unit_globals,
  Vcl.Forms;

type
  TInformacoes = class
  private
    FConexao      : TFDConnection;
    FMsgErro      : string;
    FCodInfo      : string;
    FInfo1        : string;
    FInfo2        : string;
    FInfo3        : string;
    FInfo4        : string;

  public
    property Conexao      : TFDConnection read FConexao write FConexao;
    property MsgErro      : string read FMsgErro write FMsgErro;

    property CodInfo      : string read FCodInfo write FCodInfo;
    property Info1        : string read FInfo1 write FInfo1;
    property Info2        : string read FInfo1 write FInfo2;
    property Info3        : string read FInfo1 write FInfo3;
    property Info4        : string read FInfo1 write FInfo4;

    constructor Create(vConexao: TFDConnection);
    destructor Destroy; override;

    procedure prcFechar;
    procedure prcAbrir;
    procedure prcSQLInit;

    function fncPegaInfo(sCodInfo: string; nNumInfo: Integer): string;
  end;
  var
    QryConsulta : TFDQuery;


implementation

{ TInformacoes }

constructor TInformacoes.Create(vConexao: TFDConnection);
begin
  FConexao := vConexao;
  QryConsulta := TFDQuery.Create(nil);
  QryConsulta.Connection := FConexao;
end;

destructor TInformacoes.Destroy;
begin
  QryConsulta.Destroy;
  inherited;
end;

procedure TInformacoes.prcAbrir;
var
  lOk: Boolean;
begin
  try
    try
      FConexao.Connected := True;
      lOk := True;
    except on E: Exception do
    begin
      FMsgErro := E.Message;
      lOk := False;
    end;
    end;
  finally
    gbServidorOk := lOk;
  end;
end;

procedure TInformacoes.prcFechar;
begin
  FConexao.Connected := False;
  gbServidorOk := False;
end;

procedure TInformacoes.prcSQLInit;
begin
  QryConsulta.Close;
  QryConsulta.SQL.Clear;
end;

function TInformacoes.fncPegaInfo(sCodInfo: string; nNumInfo: Integer): string;
begin
  prcFechar;
  prcAbrir;

  prcSQLInit;
  QryConsulta.SQL.Text := 'SELECT * FROM informacoes WHERE codinfo = :pCodinfo';
  QryConsulta.ParamByName('pCodinfo').AsString := sCodInfo;
  QryConsulta.Open();

  case nNumInfo of
    1 : Result := QryConsulta.FieldByName('info1').AsString;
    2 : Result := QryConsulta.FieldByName('info2').AsString;
    3 : Result := QryConsulta.FieldByName('info3').AsString;
    4 : Result := QryConsulta.FieldByName('info4').AsString;
  else Result := 'ERRO';
  end;
end;


end.
