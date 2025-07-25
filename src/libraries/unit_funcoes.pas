unit unit_funcoes;

interface

uses
  IdHMACSHA1,
  unit_HMAC,
  WWPDBEdit,
  WWPEdit,
  WWPMaskEdit,
  unit_AES,

  System.IniFiles,
  System.NetEncoding,
  System.SysUtils,
  Winapi.Windows,

  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.Mask,
  Vcl.StdCtrls,

  view.mensagens,
  unit_globals;


function fncCriarMensagem(TituloJanela, TituloMsg, Msg, Icone, Tipo : string) : Boolean;
function fncCriarMensagemGlobal(TituloJanela, TituloMsg, Msg, Icone, Tipo : string) : Boolean;
function fncRemoveCaracteres(AString : string) : string;
function fncValidaLicenca() : Boolean;
function fncValidaSenha(Usuario, Senha, SenhaDB: string): Boolean;
function Espaco(aLength: Integer): string;
function Repete(aChar: string; aLength: Integer): string;
function IIf(Condition: Boolean; TruePart, FalsePart: Variant): Variant;
function fncDataDbToDataStr(sDataDb: string): string;
function fncDataDbToData(sDataDb: string): TDate;
function fncDataDbToDataHora(sDataHoraDb: string): TDateTime;
function fncDataStrToDataDb(sDataStr: string): string;
function fncTextoEspacoFim(sTexto: string; iTamanho: Integer): string;
function fncTextoEspacoIni(sTexto: string; iTamanho: Integer): string;
procedure prcValidarCamposObrigatorios(Form : TForm);
procedure OcultarCaret(Control: TWinControl);

implementation

function IIf(Condition: Boolean; TruePart, FalsePart: Variant): Variant;
begin
  if Condition then
    Result := TruePart
  else
    Result := FalsePart;
end;

function fncCriarMensagem(TituloJanela, TituloMsg, Msg, Icone, Tipo : string) : Boolean;
begin
    Result := False;

    frmMensagem := TfrmMensagem.Create(nil);

    frmMensagem.sTituloJanela := TituloJanela;
    frmMensagem.sTituloMsg := TituloMsg;
    frmMensagem.sMensagem := Msg;
    frmMensagem.sCaminhoIcone := Icone;
    frmMensagem.sTipo := Tipo;

    frmMensagem.ShowModal;
    Result := frmMensagem.bRespostaMSG;

end;

function fncCriarMensagemGlobal(TituloJanela, TituloMsg, Msg, Icone, Tipo : string) : Boolean;
begin
    Result := False;

    msgMensagemGlobal := TfrmMensagem.Create(nil);

    msgMensagemGlobal.sTituloJanela := TituloJanela;
    msgMensagemGlobal.sTituloMsg := TituloMsg;
    msgMensagemGlobal.sMensagem := Msg;
    msgMensagemGlobal.sCaminhoIcone := Icone;
    msgMensagemGlobal.sTipo := Tipo;

    if Tipo <> 'NO_CTRL' then
    begin
      msgMensagemGlobal.ShowModal;
      Result := frmMensagem.bRespostaMSG;
    end
    else
    begin
      msgMensagemGlobal.Show;
      Result := True;
    end;


end;

function fncRemoveCaracteres(AString : string) : string;
var
  I : Integer;
  Limpos : string;
begin
  Limpos := '';
  for I := 1 to Length(AString) do
  begin
      if Pos(Copy(AString, I, 1), '"!%$#@&�*().,;:/<>[]=+-_\|') = 0 then
        Limpos := Limpos + Copy(AString, I, 1);
  end;
  Result := Limpos;

end;

procedure prcValidarCamposObrigatorios(Form : TForm);
var
  i : Integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
  begin
    if Form.Components[i].Tag = 5 then
    begin
      // TEdit
      if Form.Components[i] is TEdit then
        if ((Form.Components[i] as TEdit).Hint <> '') and
           (Trim(fncRemoveCaracteres((Form.Components[i] as TEdit).Text)) = '') then
        begin
          fncCriarMensagem('AVISO!',
                          'DADOS OBRIGAT�RIOS',
                          'O campo ' + (Form.Components[i] as TEdit).Hint + ' � obrigat�rio',
                          ExtractFilePath(Application.ExeName) + '\assets\atencao.png',
                          'OK');
          if ((Form.Components[i] as TEdit).Enabled) then
            (Form.Components[i] as TEdit).SetFocus;
          Abort;

        end;


      // WWPEdit
      if Form.Components[i] is TWWPEdit then
        if ((Form.Components[i] as TWWPEdit).Hint <> '') and
             (Trim(fncRemoveCaracteres((Form.Components[i] as TWWPEdit).Text)) = '') then
        begin
          fncCriarMensagem('AVISO!',
                            'DADOS OBRIGAT�RIOS',
                            'O campo ' + (Form.Components[i] as TWWPEdit).Hint + ' � obrigat�rio',
                            ExtractFilePath(Application.ExeName) + '\assets\atencao.png',
                            'OK');
          if ((Form.Components[i] as TWWPEdit).Enabled) then
            (Form.Components[i] as TWWPEdit).SetFocus;
          Abort;

        end;
    end;
  end;
end;

function fncValidaLicenca() : Boolean;
var
  IniFile : string;
  Ini     : TIniFile;
  sID     : string;
  sProp   : string;
  sChave  : string;
begin
  IniFile := ChangeFileExt(Application.Exename, '.ini');
  Ini     := TIniFile.Create(IniFile);

  Result := False;
  if not FileExists(IniFile) then
  begin
    Result := False;
    Ini.Free;
  end
  else
  begin
    try
      sID     := Ini.ReadString('PDV','ID','');
      sProp   := UTF8ToString(Ini.ReadString('PDV','Proprietario',''));
      sChave  := Ini.ReadString('PDV','Chave','');

      if (sID = '') or (sProp = '') or (sChave = '') then
      begin
        Result := False;
      end
      else
      begin
        if THMAC<TidHmacsha256>.ValidateLicenceKey(CKey, sProp, sID, sChave) then
        begin
          gsPDV := sID;
          gsProprietario := sProp;
          Result := True;
        end;
      end;
    finally
      Ini.Free;
    end;
  end;
end;

function fncValidaSenha(Usuario, Senha, SenhaDB: string): Boolean;
var
  valueHmac: string;
begin
  valueHmac := THMAC<TIdHMACSHA256>.HashValueBase64(CKey + Usuario.ToLower, Senha);
  Result := (SenhaDB = valueHmac);
end;

function Espaco(aLength: Integer): string;
begin
  Result := ''; // set Result to empty
  if aLength > 0 then // just length > 0
    while Length(Result) <> aLength do
      Result := Result + ' '; // inc space
end;

function Repete(aChar: string; aLength: Integer): string;
begin
  Result := ''; // set Result to empty
  if aLength > 0 then // just length > 0
    while Length(Result) <> aLength do
      Result := Result + aChar; // inc char
end;

function fncDataDbToDataStr(sDataDb: string): string;
var
  sTmp : string;
begin
  //sDataDb [yyyy-mm-dd]
  sTmp := sDataDb.Substring(8, 2) + '/';
  sTmp := sTmp + sDataDb.Substring(5, 2) + '/';
  Result := sTmp + sDataDb.Substring(0, 4);
end;

function fncDataDbToData(sDataDb: string): TDate;
begin
  Result := StrToDate(fncDataDbToDataStr(sDataDb));
end;

function fncDataDbToDataHora(sDataHoraDb: string): TDateTime;
begin
  //sDataHoraDb [yyyy-mm-dd hh:mm:ss]
  Result := StrToDateTime(fncDataDbToDataStr(sDataHoraDb) + sDataHoraDb.Substring(10));
end;

function fncDataStrToDataDb(sDataStr: string): string;
var
  sTmp : string;
begin
//sDataStr [dd/mm/yyyy]
  sTmp := sDataStr.Substring(6, 4) + '-';
  sTmp := sTmp + sDataStr.Substring(3, 2) + '-';
  Result := sTmp + sDataStr.Substring(0, 2);
end;

procedure OcultarCaret(Control: TWinControl);
begin
    HideCaret(Control.Handle);
end;

function fncTextoEspacoFim(sTexto: string;
  iTamanho: Integer): string;
begin
  if iTamanho > Trim(sTexto).Length then
    Result := Trim(sTexto) + Espaco(iTamanho - Trim(sTexto).Length)
  else
    Result := Trim(sTexto).Substring(0, iTamanho);
end;

function fncTextoEspacoIni(sTexto: string;
  iTamanho: Integer): string;
begin
  if iTamanho > Trim(sTexto).Length then
    Result := Espaco(iTamanho - Trim(sTexto).Length) + Trim(sTexto)
  else
    Result := Trim(sTexto).Substring(iTamanho - Trim(sTexto).Length);
end;

end.
