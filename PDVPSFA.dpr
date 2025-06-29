program PDVPSFA;

uses
  Vcl.Forms,
  view.caixa in 'src\views\view.caixa.pas' {frmCaixa},
  unitDados in 'src\libraries\unitDados.pas' {frmDados: TDataModule},
  view.login in 'src\views\view.login.pas' {frmLogin},
  view.configurarservidor in 'src\views\view.configurarservidor.pas' {frmConfigurarServidor},
  view.mensagens in 'src\views\view.mensagens.pas' {frmMensagem},
  unit_funcoes in 'src\libraries\unit_funcoes.pas',
  classe.conexao in 'src\libraries\classe.conexao.pas',
  System.SysUtils,
  unit_HMAC in 'src\libraries\unit_HMAC.pas',
  unit_HASH in 'src\libraries\unit_HASH.pas',
  unit_AES in 'src\libraries\unit_AES.pas',
  classe.usuarios in 'src\models\classe.usuarios.pas',
  unit_globals in 'src\libraries\unit_globals.pas',
  view.abrir_caixa in 'src\views\view.abrir_caixa.pas' {frmAbrirCaixa},
  classe.ticket in 'src\models\classe.ticket.pas',
  classe.pdvlanc in 'src\models\classe.pdvlanc.pas',
  view.caixa_aberto in 'src\views\view.caixa_aberto.pas' {frmCaixaAberto},
  view.caixa_fechado in 'src\views\view.caixa_fechado.pas' {frmCaixaFechado},
  classe.ticketitens in 'src\models\classe.ticketitens.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'PDV - PSFA';

  // Ajusta fator de tela
  gcFatorH := Screen.Width / 1280;
  gcFatorV := Screen.Height / 720;

  // Inicializa as classes de conexão com o banco de dados
  Application.CreateForm(TfrmDados, frmDados);
  gbLogado        := False;
  gbCaixaAberto   := False;

  // Valida a licença de uso através da tag [PDV] do arquivo .ini
  if not fncValidaLicenca then
  begin
    fncCriarMensagem('LICENÇA DE USO',
                     'ERRO AO VALIDAR A LICENÇA DE USO!',
                     'Não foi possível validar a CHAVE da licença de uso: CHAVE ausente ou inválida',
                     ExtractFilePath(Application.ExeName) + '\assets\erro.png',
                     'OK');
    Application.Terminate;
  end;

  // Testa a conexão com o BD
  frmDados.Conexao.prcConectarBD;

  if not gbServidorOk then
  begin
    fncCriarMensagem('CONEXÃO AO BANCO DE DADOS',
                     'ERRO AO CONECTAR AO BANCO DE DADOS!',
                     'não foi possível conectar ao Banco de Dados, possível causa: ' +
                     frmDados.Conexao.MsgErro,
                     ExtractFilePath(Application.ExeName) + '\assets\erro.png',
                     'OK');
    Application.CreateForm(TfrmConfigurarServidor, frmConfigurarServidor);
    frmConfigurarServidor.ShowModal;
    Application.Terminate;
  end;

  // Inicializa PDVLANC
  frmDados.PdvLanc := TPdvLanc.Create(frmDados.FDConnection);

  // Carrega o ID deste PDV para pesquisa
  frmDados.PdvLanc.IdPDV := gsPDV;

  // Verifica se este PDV possui CAIXA ABERTO no BD
  if frmDados.PdvLanc.fncCaixaAberto then
  // CAIXA já está aberto no BD
  begin
    fncCriarMensagem('AVISO',
                     'INICIALIZAÇÃO DO PDV!',
                     'O CAIXA ' +
                      frmDados.PdvLanc.IdCaixa +
                     ' se encontra ABERTO no banco de dados.',
                     ExtractFilePath(Application.ExeName) + '\assets\atencao.png',
                     'OK');

    // Necessário login do usuário do CAIXA aberto
    frmLogin := TfrmLogin.Create(nil);
    frmLogin.edtNomeUsuario.Text := frmDados.PdvLanc.Usuario;
    frmLogin.edtNomeUsuario.Enabled := False;
    frmLogin.ShowModal;
    frmLogin.Hide;
    frmLogin.Free;

    gbCaixaAberto := True;
    gsCaixa := frmDados.PdvLanc.IdCaixa;
  end else
  begin
    // CAIXA não está abreto no BD
    gbCaixaAberto := False;
  end;


  // Se não tem CAIXA aberto no BD, solicita login de novo operador
  if not gbLogado then
  begin
    frmLogin := TfrmLogin.Create(nil);
    frmLogin.ShowModal;
    frmLogin.Hide;
    frmLogin.Free;
  end;

  // Após operador logado, entra no CAIXA FECHADO ou ABERTO
  if gbLogado then
  begin
    Application.CreateForm(TfrmCaixa, frmCaixa)
  end;

  Application.Run;


end.
