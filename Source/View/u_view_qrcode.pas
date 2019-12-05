unit u_view_qrcode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.GIFImg;

type
  Tfrm_view_qrcode = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    Image2: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    qrCode: string;
    procedure loadQRCode(st: string);

  end;

var
  frm_view_qrcode: Tfrm_view_qrcode;

implementation

uses uTInject, System.NetEncoding, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

{$R *.dfm}

procedure Tfrm_view_qrcode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := cafree;
  frm_view_qrcode := nil;
end;

procedure Tfrm_view_qrcode.FormCreate(Sender: TObject);
begin
  (Image2.Picture.Graphic as TGIFImage ).Animate := True;

  (Image2.Picture.Graphic as TGIFImage ).AnimationSpeed:= 500;
end;

procedure Tfrm_view_qrcode.FormShow(Sender: TObject);
begin
  timer1.enabled := true;
end;

procedure Tfrm_view_qrcode.loadQRCode(st: string);
var
  LInput: TMemoryStream;
  LOutput: TMemoryStream;
  stl: TStringList;
  PNG: TpngImage;
begin
  //by Aurino Inovatechi 19/11/2019 review Mike
  LInput  := TMemoryStream.Create;
  LOutput := TMemoryStream.Create;
  stl     := TStringList.Create;
  try
    stl.Add(copy(st, 23, length(st)));
    stl.SaveToStream(LInput);

    LInput.Position := 0;
    TNetEncoding.Base64.Decode( LInput, LOutput );
    LOutput.Position := 0;

    //Delphi 10.3
    {$IFDEF VER330}
      if LOutput.size > 0 then
        Image1.Picture.LoadFromStream(LOutput);
    {$ELSE}
    PNG := TPngImage.Create;
    try
      //Delphi 10.1,2 ....
      if LOutput.size > 0 then
         PNG.LoadFromStream(LOutput);
      image1.Picture.Graphic := PNG;
    finally
      PNG.Free;
    end;
    {$ENDIF}

  finally
    LInput.Free;
    LOutput.Free;
    FreeAndNil(stl);
  end;
end;

procedure Tfrm_view_qrcode.Timer1Timer(Sender: TObject);
var
  _inject : TInjectWhatsapp;
begin
  if assigned( _inject ) then
     _inject.monitorQrCode;

  if Image1.Picture.Graphic <> nil    then
     frm_view_qrcode.Caption := 'TInject - Aponte seu celular agora!';
 end;

end.
