unit view.configurarservidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Buttons, WWPEdit;

type
  TfrmConfigurarServidor = class(TForm)
    shpFundo: TShape;
    pnlTopo: TPanel;
    pnlConfNovas: TPanel;
    pnlConfAtuais: TPanel;
    pnlContainer: TPanel;
    lblConfServ: TLabel;
    pnlEntrar: TPanel;
    btnGravar: TSpeedButton;
    pnlCancelar: TPanel;
    btnCancelar: TSpeedButton;
    lblTituloNova: TLabel;
    lblTituloAtual: TLabel;
    pnlSeparadorNova: TPanel;
    pnlSeparadorAtual: TPanel;
    lblNomeServidor: TLabel;
    lblPorta: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    lblBancoDados: TLabel;
    edtNomeServidorAtual: TEdit;
    edtPortaAtual: TEdit;
    edtUsuarioAtual: TEdit;
    edtSenhaAtual: TEdit;
    lblNomeServidorAtual: TLabel;
    lblPortaAtual: TLabel;
    lblUsuarioAtual: TLabel;
    lblSenhaAtual: TLabel;
    edtBancoDadosAtual: TEdit;
    lblBancoDadosAtual: TLabel;
    imgConfiguracaoServidor: TImage;
    edtNomeServidor: TWWPEdit;
    edtPorta: TWWPEdit;
    edtBancoDados: TWWPEdit;
    edtUsuario: TWWPEdit;
    edtSenha: TWWPEdit;
    procedure btnGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfigurarServidor: TfrmConfigurarServidor;

implementation

uses
  unit_funcoes, unitDados, unit_globals;

{$R *.dfm}

procedure TfrmConfigurarServidor.btnGravarClick(Sender: TObject);
begin
  prcValidarCamposObrigatorios(frmConfigurarServidor);

  frmDados.Conexao.Servidor  := edtNomeServidor.Text;
  frmDados.Conexao.Porta     := edtPorta.Text;
  frmDados.Conexao.Base      := edtBancoDados.Text;
  frmDados.Conexao.Usuario   := edtUsuario.Text;
  frmDados.Conexao.Senha     := edtSenha.Text;

  frmDados.Conexao.prcGravarArquivoINI;

  frmDados.Conexao.prcConectarBD;

  if gbServidorOk then
  begin



    fncCriarMensagem('CONEXÃO AO BANCO DE DADOS',
                     'BANCO DE DADOS CONECTATO COM SUSSESSO!',
                     'SERVIDOR = ' + frmDados.Conexao.Servidor + ':' +
                     frmDados.Conexao.Porta +
                     'A aplicação de ser reiniciada!',
                     ExtractFilePath(Application.ExeName) + '\assets\ok.png',
                     'OK');
    Application.Terminate;

  end
  else
  begin
    fncCriarMensagem('CONEXÃO AO BANCO DE DADOS',
                     'ERRO AO CONECTAR AO BANCO DE DADOS!',
                     'não foi possível conectar ao Banco de Dados, possível causa:' +
                     frmDados.Conexao.MsgErro,
                     ExtractFilePath(Application.ExeName) + '\assets\erro.png',
                     'OK');
    edtNomeServidor.SetFocus;
  end;
end;

procedure TfrmConfigurarServidor.FormShow(Sender: TObject);
begin
  if frmDados.Conexao.fncLerArquivoINI then
  begin
    edtNomeServidorAtual.Text := frmDados.Conexao.Servidor;
    edtPortaAtual.Text := frmDados.Conexao.Porta;
    edtBancoDadosAtual.Text := frmDados.Conexao.Base;
    edtUsuarioAtual.Text := frmDados.Conexao.Usuario;
    edtSenhaAtual.Text := frmDados.Conexao.Senha;
  end;
end;

end.
