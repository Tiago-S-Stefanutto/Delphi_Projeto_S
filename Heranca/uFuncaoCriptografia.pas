unit uFuncaoCriptografia;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uEnum, System.UITypes, uDTMConexao, System.Hash;

function GerarSalt: string;
function GerarHash(const Senha, Salt: string): string;

implementation

function GerarSalt: string;
begin
  Result := Copy(THashSHA2.GetHashString(GuidToString(TGUID.NewGuid)), 1, 16);
end;

function GerarHash(const Senha, Salt: string): string;
begin
  Result := THashSHA2.GetHashString(Salt + Senha);
end;

end.
