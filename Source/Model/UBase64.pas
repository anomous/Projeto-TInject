﻿{** Douglas Colombo
  * Classe de conversão de arquivos em texto
  * e de Texto em Arquivos, BASE64
  
  * MODIFICADO 04/12/2019 POR Daniel Rodrigues (ajustes de plataforma) 
  *
  *
**}

unit UBase64;

interface

uses System.Classes, System.netEncoding, System.SysUtils, VCL.Graphics;


//Type
  // tBase64 = class

   //public
     procedure Base64ToFile(Arquivo, caminhoSalvar : String);
     function Base64ToStream(imagem : String) : TMemoryStream;
     //function Base64ToBitmap(imagem : String) : TBitmap;
     function BitmapToBase64(imagem : TBitmap) : String;
     function FileToBase64(Arquivo : String) : String;
     function StreamToBase64(STream : TMemoryStream) : String;
//end;

implementation


//{ tBase64 }
//function tBase64.Base64ToBitmap(imagem: String): TBitmap;
//Var sTream : TMemoryStream;
//begin
//  if (trim(imagem) <> '') then
//  begin
//     Try
//        sTream := Base64ToStream(imagem);
//        result := TBitmap.CreateFromStream(sTream);
//     Finally
//        sTream.DisposeOf;
//        sTream := nil;
//     End;
//  end else
//  exit;
//end;

procedure Base64ToFile(Arquivo, caminhoSalvar : String);
Var sTream : TMemoryStream;
begin
  Try
    sTream := Base64ToStream(Arquivo);
    sTream.SaveToFile(caminhoSalvar);
  Finally
//    sTream.Free;
//    sTream:=nil;
    FreeAndNil(sTream);
  End;
end;

function Base64ToStream(imagem: String): TMemoryStream;
var Base64 : TBase64Encoding;
    bytes : tBytes;
begin
  Try
    Base64 := TBase64Encoding.Create;
    bytes  := Base64.DecodeStringToBytes(imagem);
    result := TBytesStream.Create(bytes);
    result.Seek(0, 0);
  Finally
    FreeAndNil(Base64);
//    Base64.Free;
//    Base64:=nil;
    SetLength(bytes, 0);
  End;
end;

function BitmapToBase64(imagem: TBitmap): String;
Var sTream : TMemoryStream;
begin
  result := '';
  if not (imagem.Empty) then
  begin
     Try
       sTream := TMemoryStream.Create;
       try
         imagem.SaveToStream(sTream);
         result := StreamToBase64(sTream);
       finally
        FreeAndNil(Stream);
//         sTream.DisposeOf;
//         sTream := nil;
       end;
     Except
     End;
  end;
end;

function FileToBase64(Arquivo : String): String;
Var sTream : tMemoryStream;
begin
  sTream := TMemoryStream.Create;
  Try
    sTream.LoadFromFile(Arquivo);
    result := StreamToBase64(sTream);
  Finally
    FreeAndNil(Stream);
//    Stream.Free;
//    Stream:=nil;
  End;
end;

function StreamToBase64(STream: TMemoryStream): String;
Var Base64 : tBase64Encoding;
begin
  Try
    Stream.Seek(0, 0);
    Base64 := TBase64Encoding.Create;
    Result := Base64.EncodeBytesToString(sTream.Memory, sTream.Size);
  Finally
    FreeAndNil(Stream);
//    Base64.Free;
//    Base64:=nil;
  End;
end;

end.
