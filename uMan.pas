unit uMan;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    b_01: TButton;
    b_02: TButton;
    cr_component: TCircle;
    Memo1: TMemo;
    Circle1: TCircle;
    Path1: TPath;
    procedure b_01Click(Sender: TObject);
    procedure b_02Click(Sender: TObject);
    procedure cr_componentClick(Sender: TObject);
    procedure Path1Click(Sender: TObject);
  private
    { Private declarations }
  function ComponentToStringProc(Component: TComponent): string;
  function StringToComponentProc(Value: string): TComponent;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.b_01Click(Sender: TObject);
begin
  Memo1.Text:= ComponentToStringProc(Path1);
end;



procedure TForm1.b_02Click(Sender: TObject);
begin
  var cr_ := StringToComponentProc(Memo1.Text);
  TCircle(cr_).Parent := self;
end;

function TForm1.StringToComponentProc(Value: string): TComponent;
var
  StrStream:TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result:= BinStream.ReadComponent(nil);
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

function TForm1.ComponentToStringProc(Component: TComponent): string;
var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

procedure TForm1.cr_componentClick(Sender: TObject);
begin
  cr_component.Free
end;

procedure TForm1.Path1Click(Sender: TObject);
begin
  Path1.Free
end;

end.
