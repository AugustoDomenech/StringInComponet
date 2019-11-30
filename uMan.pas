unit uMan;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, system.generics.collections,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Colors;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    b_01: TButton;
    b_02: TButton;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Path_arrow: TPath;
    TrackBar1: TTrackBar;
    Rectangle2: TRectangle;
    Path_circle: TPath;
    Rectangle3: TRectangle;
    Path_text: TPath;
    Image: TImage;
    ColorPanel1: TColorPanel;
    FDConnection: TFDConnection;
    Query: TFDQuery;
    Memo1: TMemo;
    Selection: TSelection;
    procedure b_01Click(Sender: TObject);
    procedure b_02Click(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure ImageClick(Sender: TObject);
  private
    { Private declarations }

  f_list_notes_objects : TList<TPath>;
  f_notes_objects_selected : TPath;


  { evento de criação dos objetos }
  procedure notes_add_objects(p_owner : TObject);

  { eventos de seleção e deseleção }
  procedure notes_select_object(p_Component: TPath);
  procedure notes_diselect_object(p_Component: TPath);

  { eventos padrao dos objetos }
  procedure onClick_default_notes_objects(Sender: TObject);

  { eventos de salvar e carregar os objetos }
  procedure notes_save;

  function ComponentToStringProc(Component: TComponent): string;
  function StringToComponentProc(Value: string): TComponent;


  public
    { Public declarations }
  end;
const
  path_circle = 'M255,0C114.75,0,0,114.75,0,255s114.75,255,255,255s255-114.75,255-255S395.25,0,255,0z M255,459 c-112.2,0-204-91.8-204-204S142.8,51,255,51s204,91.8,204,204S367.2,459,255,459z';

  path_arrow = 'M377.816009521484,7.49200010299683 C372.503997802734,2.14800000190735 366.088012695313,0 358.608001708984,0 L98.5439987182617,0 C83.1039962768555,0 69.463996887207,10.9879999160767'
             + '69.463996887207,26.42799949646 L69.463996887207,50.1520004272461 C69.463996887207,65.5920028686523 83.1039962768555,80 98.5439987182617,80 L251.467987060547,80 L8.46399974822998,322.079986572266'
             + 'C3.19599962234497,327.351989746094 0.291999816894531,333.919982910156 0.288000106811523,341.419982910156 C0.288000106811523,348.919982910156 3.19600009918213,355.715972900391 8.46399974822998,'
             + '360.987976074219 L25.2399997711182,377.640014648438 C30.503999710083,382.912017822266 37.5359992980957,385.756011962891 45.0359992980957,385.756011962891 C52.5359992980957,385.756011962891'
             + '58.8040008544922,382.828002929688 64.0719985961914,377.555999755859 L305.463989257813,135.384002685547 L305.463989257813,286.507995605469 C305.463989257813,301.951995849609 319.547973632813,'
             + '316 334.983978271484,316 L358.715972900391,316 C374.147979736328,316 385.467987060547,301.951995849609 385.467987060547,286.507995605469 L385.467987060547,26.5200004577637 C385.463989257813,'
             + '19.0480003356934 383.144012451172,12.7880001068115 377.816009521484,7.49200010299683 Z ';

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.b_01Click(Sender: TObject);
begin
//  Memo1.Text:= ComponentToStringProc( );
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

procedure TForm1.ImageClick(Sender: TObject);
begin
  notes_diselect_object(f_notes_objects_selected);
end;

procedure TForm1.notes_add_objects(p_owner : TObject);
begin
  if f_list_notes_objects = nil then
    f_list_notes_objects := TList<TPath>.create;

  var il_new_object := TPath.Create(nil);

  il_new_object.OnClick := onClick_default_notes_objects;

  il_new_object.Parent := image;

  il_new_object.Height := 80;
  il_new_object.Height := 80;

  il_new_object.position.x := (Image.Width / 2) - (il_new_object.Width / 2);
  il_new_object.position.y := (Image.Height / 2) - (il_new_object.Height / 2);


  case TComponent(p_owner).Tag of
    01: il_new_object.Data.Data := Path_arrow.Data.Data;
    02: il_new_object.Data.Data := Path_circle.Data.Data;
  end;

  notes_select_object(il_new_object);

  f_list_notes_objects.Add(il_new_object);
end;

procedure TForm1.notes_diselect_object(p_Component: TPath);
begin

  if p_Component = nil then
    exit;

  p_Component.Align := TAlignLayout.none;

  p_Component.Height := Selection.Height - ( Selection.Padding.Top  + Selection.Padding.Bottom );
  p_Component.Width  := Selection.Width  - ( Selection.Padding.Left + Selection.Padding.Right );

  p_Component.Parent := image;

  p_Component.Position.X := Selection.Position.X + Selection.Padding.Left;
  p_Component.Position.Y := Selection.Position.Y + Selection.Padding.Top;

  Selection.Padding.Rect := RectF(0,0,0,0);

  p_Component.HitTest := true;

  Selection.Visible := false;

  f_list_notes_objects := nil;
end;

procedure TForm1.notes_save;
begin
  if ( f_list_notes_objects = nil ) or ( f_list_notes_objects.Count <= 0 ) then
    exit;


end;

procedure TForm1.notes_select_object(p_Component: TPath);
begin
  if p_Component = nil then
    exit;

  notes_diselect_object(f_notes_objects_selected);

  Selection.Padding.Rect := RectF(10,10,10,10);

  Selection.Position.X := p_Component.Position.X - Selection.Padding.Left;
  Selection.Position.Y := p_Component.Position.Y - + Selection.Padding.Top;

  Selection.Height := p_Component.Height + ( Selection.Padding.Top  + Selection.Padding.Bottom );
  Selection.Width  := p_Component.Width  + ( Selection.Padding.Left + Selection.Padding.Right );

  p_Component.Parent := Selection;

  p_Component.Align := TAlignLayout.Client;

  p_Component.HitTest := false;

  Selection.Visible := true;

  f_notes_objects_selected := p_Component;

end;

procedure TForm1.onClick_default_notes_objects(Sender: TObject);
begin
  if Sender is Tpath then
    notes_select_object( Tpath(sender) );
end;

procedure TForm1.Rectangle1Click(Sender: TObject);
begin
  notes_add_objects(sender)
end;

end.
