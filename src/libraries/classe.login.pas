unit classe.login;

interface

type
  TLogin = class
    private
    Flogado: Boolean;
    Fnivel: Integer;
    Fnome: String;

    public
      property logado     : Boolean read Flogado write Flogado;
      property nivel      : Integer read Fnivel write Fnivel;
      property nome       : String read Fnome write Fnome;

      constructor Create();
      destructor Destroy; override;

      procedure prcLogin();
      procedure prcLogout();
  end;

implementation

uses
  classe.usuarios;


{ TLogin }

constructor TLogin.Create;
begin
  Flogado := False;
end;

destructor TLogin.Destroy;
begin

  inherited;
end;

procedure TLogin.prcLogin;
begin

end;

procedure TLogin.prcLogout;
begin

end;

end.
