unit classe.caixaaberto;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.DApt,
  System.SysUtils,
  Vcl.Forms;

Type
  TCaixaaberto = class
    private
      FConexao    : TFDConnection;
      FMsgErro    : string;
      FidPDV      : string;
      FidCaixa    : string;
      FidUsuario  : Integer;
      FUsuario    : string;

    public
      property Conexao    : TFDConnection read FConexao write FConexao;
      property MsgErro    : string Read FMsgErro Write FMsgErro;
      property IdPDV      : string read FidPDV write FidPDV;
      property IdCaixa    : string read FidCaixa write FidCaixa;
      property IdUsuario  : Integer read FidUsuario write FidUsuario;
      property Usuario    : string read FUsuario write FUsuario;

      constructor Create(Conexao : TFDConnection);
      destructor Destroy; override;

      function fncCaixaDisponivel: Boolean;
      function prcGravar: Boolean;
      procedure prcCaixaaberto;
      procedure prcFechar;
      procedure prcAbrir;
  end;

implementation

uses
  unit_funcoes, unit_globals;

{ TCaixaaberto }

procedure TCaixaaberto.prcCaixaAberto;
var
  QryConsulta : TFDQuery;
  liCaixa: Integer;
begin
  FidCaixa := '';
  QryConsulta := TFDQuery.Create(nil);
  QryConsulta.Connection := FConexao;
  try
    Self.prcFechar;
    Self.prcAbrir;

    QryConsulta.Close;
    QryConsulta.SQL.Clear;
    QryConsulta.SQL.Add('SELECT ca.idpdv, ca.idcaixa, ca.idusuario, usr.usuario ');
    QryConsulta.SQL.Add('FROM caixaaberto ca INNER JOIN usuario usr ');
    QryConsulta.SQL.Add('ON ca.idusuario = usr.idusuario ');
    QryConsulta.SQL.Add('WHERE ca.idpdv = :pIdPDV');
    QryConsulta.ParamByName('pIdPDV').AsString := FidPDV;
    QryConsulta.Open;

    if QryConsulta.RecordCount > 0 then
    begin
      FidCaixa    := QryConsulta.FieldByName('idcaixa').AsString;
      FidUsuario  := QryConsulta.FieldByName('idusuario').AsInteger;
      FUsuario    := QryConsulta.FieldByName('usuario').AsString;
    end
    else
      FidCaixa := '';
  finally
    QryConsulta.Destroy;
  end;
end;

function TCaixaaberto.fncCaixaDisponivel: Boolean;
var
  QryConsulta : TFDQuery;
  lbDisponivel: Boolean;
begin
  lbDisponivel := False;
  QryConsulta := TFDQuery.Create(nil);
  try
    Self.prcFechar;
    Self.prcAbrir;

    QryConsulta.Connection := FConexao;

    QryConsulta.Close;
    QryConsulta.SQL.Clear;
    QryConsulta.SQL.Add('SELECT * FROM caixaaberto WHERE idcaixa = :pIdCaixa');
    QryConsulta.ParamByName('pIdCaixa').AsString := FidCaixa;
    QryConsulta.Open;

    if QryConsulta.RecordCount > 0 then
      lbDisponivel := False
    else
      lbDisponivel := True;
  finally
    Result := lbDisponivel;
    QryConsulta.Destroy;
  end;

end;

constructor TCaixaaberto.Create(Conexao: TFDConnection);
begin
  FConexao := Conexao;
end;

destructor TCaixaaberto.Destroy;
begin

  inherited;
end;

procedure TCaixaaberto.prcAbrir;
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

procedure TCaixaaberto.prcFechar;
begin
  FConexao.Connected  := False;
  gbServidorOk        := False;
end;

function TCaixaaberto.prcGravar: Boolean;
var
  QryInserir: TFDQuery;
begin
  QryInserir := TFDQuery.Create(nil);
  try
    try
      Self.prcFechar;
      Self.prcAbrir;

      QryInserir.Connection := FConexao;

      QryInserir.Close;
      QryInserir.SQL.Clear;

      QryInserir.SQL.Add('INSERT INTO caixaaberto (idpdv, idcaixa, idusuario) ');
      QryInserir.SQL.Add('VALUES (:p_idpdv, :p_idcaixa, :p_idusuario)');

      QryInserir.ParamByName('p_idpdv').AsString := FidPDV;
      QryInserir.ParamByName('p_idcaixa').AsString := FidCaixa;
      QryInserir.ParamByName('p_idusuario').AsInteger := FidUsuario;

      QryInserir.ExecSQL;

      Result := True;
    except on E: Exception do
      begin
        MsgErro := E.Message;
        Result := False;
      end;
    end;
  finally
    QryInserir.Destroy;
  end;

end;

end.
