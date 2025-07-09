unit view.mensagensimples;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmMensagemSimples = class(TForm)
    pnlFundo: TPanel;
    shpFundo: TShape;
    lblTituloMsg: TLabel;
    lblMsg: TLabel;
    imgMsgIcone: TImage;
    pnlBarraTopo: TPanel;
    lblTituloJanela: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMensagemSimples: TfrmMensagemSimples;

implementation

{$R *.dfm}

procedure TfrmMensagemSimples.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  frmMensagemSimples := nil;
end;

end.
