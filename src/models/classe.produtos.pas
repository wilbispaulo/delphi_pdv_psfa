unit classe.produtos;

interface
uses
  entity.produtos,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  System.SysUtils,
  System.Generics.Collections,
  unit_funcoes,
  unit_globals,
  Vcl.Forms;

type
  TProdutos = class(TProdutosEntity)
  private
    FConexao      : TFDConnection;
    FMsgErro      : string;

  public
    property Conexao      : TFDConnection read FConexao write FConexao;
    property MsgErro      : string read FMsgErro write FMsgErro;

    constructor Create(vConexao: TFDConnection);
    destructor Destroy; override;

    procedure prcFechar;
    procedure prcAbrir;
    procedure prcSQLInit;

    function fncProcuraProduto(sCodDigi: string): TList<TProdutosEntity>;

  end;
  var
    QryConsulta : TFDQuery;

implementation

{ TProdutos }

constructor TProdutos.Create(vConexao: TFDConnection);
begin
  FConexao := vConexao;
  QryConsulta := TFDQuery.Create(nil);
  QryConsulta.Connection := FConexao;
end;

destructor TProdutos.Destroy;
begin
  QryConsulta.Destroy;
  inherited;
end;

procedure TProdutos.prcAbrir;
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

procedure TProdutos.prcFechar;
begin
  FConexao.Connected := False;
  gbServidorOk := False;
end;

procedure TProdutos.prcSQLInit;
begin
  QryConsulta.Close;
  QryConsulta.SQL.Clear;
end;

function TProdutos.fncProcuraProduto(sCodDigi: string): TList<TProdutosEntity>;
var
  lstLista : TList<TProdutosEntity>;
  lProdutos : TProdutosEntity;
begin
  lstLista    := TList<TProdutosEntity>.Create;

  try
    prcFechar;
    prcAbrir;

    prcSQLInit;
    QryConsulta.SQL.Text := 'SELECT * FROM produtos WHERE coddigi = :pCoddigi';
    QryConsulta.ParamByName('pCoddigi').AsString := sCodDigi;
    QryConsulta.Open;

    lProdutos   := TProdutosEntity.Create;
    try
      lProdutos.CodGrupo    := QryConsulta.FieldByName('codgrupo').AsString;
      lProdutos.CodProd     := QryConsulta.FieldByName('codprod').AsString;
      lProdutos.Descr       := QryConsulta.FieldByName('descr').AsString;
      lProdutos.Und         := QryConsulta.FieldByName('und').AsString;
      lProdutos.ValUnit     := QryConsulta.FieldByName('valunit').AsCurrency;
      lProdutos.Inativo     := QryConsulta.FieldByName('inativo').AsString;
      lProdutos.QtdAviso    := QryConsulta.FieldByName('qtdaviso').AsInteger;
      lProdutos.Ativa1      := QryConsulta.FieldByName('ativa1').AsString;
      lProdutos.Ativa2      := QryConsulta.FieldByName('ativa2').AsString;
      lProdutos.Ativa3      := QryConsulta.FieldByName('ativa3').AsString;
      lProdutos.Qtd1        := QryConsulta.FieldByName('qtd1').AsInteger;
      lProdutos.Qtd2        := QryConsulta.FieldByName('qtd2').AsInteger;
      lProdutos.Qtd3        := QryConsulta.FieldByName('qtd3').AsInteger;
      lProdutos.ValUnit1    := QryConsulta.FieldByName('valunit1').AsCurrency;
      lProdutos.ValUnit2    := QryConsulta.FieldByName('valunit2').AsCurrency;
      lProdutos.ValUnit3    := QryConsulta.FieldByName('valunit3').AsCurrency;
      lProdutos.DescGrupo   := QryConsulta.FieldByName('descgrupo').AsString;
      lstLista.Add(lProdutos);
    except
      lProdutos.Free;
    end;
  finally
    Result := lstLista;
  end;
end;

end.
