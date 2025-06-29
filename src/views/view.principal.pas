unit view.principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, unit_globals,
  Vcl.Imaging.pngimage, unitDados, Vcl.Menus;

type
  TviewPrincipal = class(TForm)
    pnlInfo: TPanel;
    pnlInfoCaixa: TPanel;
    lblLInfoCaixa: TLabel;
    lblInfoCaixa: TLabel;
    pnlInfoOp: TPanel;
    lblLInfoOp: TLabel;
    lblInfoOp: TLabel;
    pnlInfoTicket: TPanel;
    lblLInfoTicket: TLabel;
    lblInfoTicket: TLabel;
    pnlInfoStatus: TPanel;
    lblInfoStatus: TLabel;
    pnlInfoHora: TPanel;
    lblInfoHora: TLabel;
    pnlInfoData: TPanel;
    lblInfoData: TLabel;
    tmrPDVHora: TTimer;
    pnlStatus: TPanel;
    pnlStatusServidor: TPanel;
    imgServidor: TImage;
    imgStatusServidor: TImage;
    lblServidorEnd: TLabel;
    pnlVersao: TPanel;
    lblStatusVersao: TLabel;
    procedure tmrPDVHoraTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function fncServidorOk(): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  viewPrincipal: TviewPrincipal;

implementation

{$R *.dfm}

function TviewPrincipal.fncServidorOk: Boolean;
begin
  if dtmdlDB.FDConnection.Connected then
  begin
    imgStatusServidor.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\assets\ok48.png');
    lblServidorEnd.Caption := dtmdlDB.FDConnection.Params.Values['Server'];
    Result := True;
  end
  else
  begin
    imgStatusServidor.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\assets\erro.png');
    lblServidorEnd.Caption := dtmdlDB.FDConnection.Params.Values['Server'];
    Result := False;
  end;
end;

procedure TviewPrincipal.FormShow(Sender: TObject);
begin
  pnlInfo.Color         := CCorFechado;
  lblInfoCaixa.Caption  := '';
  lblInfoOp.Caption     := gsNomeUsuario;
  lblInfoTicket.Caption := 'FECHADO';
  lblInfoStatus.Caption := 'CAIXA FECHADO';
  lblInfoHora.Caption   := TimeToStr(Now);
  lblInfoData.Caption   := FormatDateTime('ddd, d mmm yyyy',Date).ToUpper;

  dtmdlDB.Fechar;
  dtmdlDB.Abrir;

  gbServidorOk := fncServidorOk();
end;

procedure TviewPrincipal.tmrPDVHoraTimer(Sender: TObject);
begin
  lblInfoHora.Caption := TimeToStr(Now);
  lblInfoData.Caption := FormatDateTime('ddd, d mmm yyyy',Date).ToUpper;
end;

end.
