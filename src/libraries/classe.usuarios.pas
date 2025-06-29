unit classe.usuarios;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.DApt,
  System.SysUtils,
  Vcl.Forms;

Type
  TUsuarios = class
    private
      FConexao    : TFDConnection;
      Fidusuario  : Integer;
      Fusuario    : String;
      Fsenha      : String;
      Fnivel      : Integer;
      Fnome       : string;
      FMsgErro    : string;
    public
      property Conexao    : TFDConnection read FConexao write FConexao;
      property idusuario  : Integer read Fidusuario;
      property usuario    : String read Fusuario write Fusuario;
      property senha      : String read Fsenha write Fsenha;
      property nivel      : Integer read Fnivel write Fnivel;
      property nome       : String read Fnome write Fnome;
      property MsgErro    : string Read FMsgErro Write FMsgErro;

      constructor Create(Conexao : TFdConnection);
      destructor Destroy; override;

      function fncInserirAlterar(TipoOperacao: String; out Erro: string): Boolean;
      function fncConsulta(sUsuario: string): TFDQuery;
      procedure prcDeleta(Usuario: String);
      procedure prcFechar;
      procedure prcAbrir;

  end;

var
  QryConsulta : TFDQuery;


implementation

uses
  unit_funcoes, unit_globals;

{ TUsuarios }

constructor TUsuarios.Create(Conexao: TFdConnection);
begin
  FConexao := Conexao;
  QryConsulta := TFDQuery.Create(nil);
  QryConsulta.Connection := FConexao;
end;

destructor TUsuarios.Destroy;
begin
  QryConsulta.Destroy;
  inherited;
end;

function TUsuarios.fncConsulta(sUsuario: string): TFDQuery;
begin
  try
    Self.prcFechar;
    Self.prcAbrir;

    QryConsulta.Close;
    QryConsulta.SQL.Clear;
    QryConsulta.SQL.Add('SELECT idusuario, usuario, senha, nivel, nome ');
    QryConsulta.SQL.Add('FROM usuario WHERE usuario = :pUsuario');
    QryConsulta.ParamByName('pUsuario').AsString := sUsuario;
    QryConsulta.Open;
  finally
    Result := QryConsulta;
  end;

end;

function TUsuarios.fncInserirAlterar(TipoOperacao: String;
  out Erro: string): Boolean;
begin
  Result := True;
end;

procedure TUsuarios.prcAbrir;
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

procedure TUsuarios.prcDeleta(Usuario: String);
begin
  if fncCriarMensagem('CONFIRMAÇÃO', 'Excluir dados',
                      'Tem certeza que deseja EXCLUIR esse USUÁRIO?',
                      ExtractFilePath(Application.ExeName) + '\assets\aviso.png',
                      'AVISO') then
  begin
    FConexao.Connected := False;
    FConexao.Connected := True;

    FConexao.ExecSQL('DELETE FROM usuario WHERE usuario = :usuario', [Usuario]);
  end;

end;

procedure TUsuarios.prcFechar;
begin
  FConexao.Connected  := False;
  gbServidorOk        := False;
end;

end.
