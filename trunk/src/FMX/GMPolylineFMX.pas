{
GMPolylineFMX unit

  ES: contiene las clases FMX necesarias para mostrar polil�neas en un mapa de
      Google Maps mediante el componente TGMMap
  EN: includes the FMX classes needed to show polylines on Google Map map using
      the component TGMMap

=========================================================================
MODO DE USO/HOW TO USE

  ES: poner el componente en el formulario, linkarlo a un TGMMap y poner las
      polil�neas a mostrar
  EN: put the component into a form, link to a TGMMap and put the polylines to
      show
=========================================================================
History:

ver 0.1.9
  ES:
    nuevo: documentaci�n
    nuevo: se hace compatible con FireMonkey
  EN:
    new: documentation
    new: now compatible with FireMonkey
=========================================================================
IMPORTANTE PROGRAMADORES: Por favor, si tienes comentarios, mejoras,
  ampliaciones, errores y/o cualquier otro tipo de sugerencia, env�ame un correo a:
  gmlib@cadetill.com

IMPORTANT PROGRAMMERS: please, if you have comments, improvements, enlargements,
  errors and/or any another type of suggestion, please send me a mail to:
  gmlib@cadetill.com
=========================================================================

Copyright (�) 2012, by Xavier Martinez (cadetill)

@author Xavier Martinez (cadetill)
@web  http://www.cadetill.com
}
{*------------------------------------------------------------------------------
  The GMPolylineFMX unit includes the FMX classes needed to show polylines on Google Map map using the component TGMMap.

  @author Xavier Martinez (cadetill)
  @version 0.1.9
-------------------------------------------------------------------------------}
{=------------------------------------------------------------------------------
  La unit GMPolylineFMX contiene las clases FMX necesarias para mostrar polil�neas en un mapa de Google Maps mediante el componente TGMMap

  @author Xavier Martinez (cadetill)
  @version 0.1.9
-------------------------------------------------------------------------------}
unit GMPolylineFMX;

interface

uses
  System.Classes, System.UITypes,

  GMPolyline, GMLinkedComponents;

type
  {*------------------------------------------------------------------------------
    FMX class to determine the symbol to show along the path.
  -------------------------------------------------------------------------------}
  {=------------------------------------------------------------------------------
    Clase FMX para determinar el s�mbolo a mostrar a lo largo del camino.
  -------------------------------------------------------------------------------}
  TSymbol = class(TCustomSymbol)
  private
    {*------------------------------------------------------------------------------
      The fill color.
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Color de relleno.
    -------------------------------------------------------------------------------}
    FFillColor: TAlphaColor;
    {*------------------------------------------------------------------------------
      The stroke color.
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Color del trazo.
    -------------------------------------------------------------------------------}
    FStrokeColor: TAlphaColor;
    procedure SetFillColor(const Value: TAlphaColor);
    procedure SetStrokeColor(const Value: TAlphaColor);
  protected
    function GetFillColor: string; override;
    function GetStrokeColor: string; override;
  public
    constructor Create; override;

    procedure Assign(Source: TPersistent); override;
  published
    property FillColor: TAlphaColor read FFillColor write SetFillColor;
    property StrokeColor: TAlphaColor read FStrokeColor write SetStrokeColor;
  end;

  {*------------------------------------------------------------------------------
    FMX class to determine the icon and repetition to show.
  -------------------------------------------------------------------------------}
  {=------------------------------------------------------------------------------
    Clase FMX para determinar el icono y la repetici�n a mostrar.
  -------------------------------------------------------------------------------}
  TIconSequence = class(TCustomIconSequence)
  public
    constructor Create(aOwner: TBasePolyline); override;
  end;

  {*------------------------------------------------------------------------------
    FMX base class for polylines and polygons.
  -------------------------------------------------------------------------------}
  {=------------------------------------------------------------------------------
    Clase FMX base para las polilineas y pol�gonos.
  -------------------------------------------------------------------------------}
  TBasePolylineFMX = class(TBasePolyline)
  private
    {*------------------------------------------------------------------------------
      The stroke color.
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Color del trazo.
    -------------------------------------------------------------------------------}
    FStrokeColor: TAlphaColor;
    procedure SetStrokeColor(const Value: TAlphaColor);
  protected
    function GetStrokeColor: string; override;
  public
    constructor Create(Collection: TCollection); override;

    procedure Assign(Source: TPersistent); override;
  published
    property StrokeColor: TAlphaColor read FStrokeColor write SetStrokeColor;
  end;

  {*------------------------------------------------------------------------------
    FMX class for polylines.
  -------------------------------------------------------------------------------}
  {=------------------------------------------------------------------------------
    Clase FMX para los polilineas.
  -------------------------------------------------------------------------------}
  TPolyline = class(TBasePolylineFMX)
  private
    {*------------------------------------------------------------------------------
      Features for icon and repetition.
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Caracter�sticas para el icono y la repetici�n.
    -------------------------------------------------------------------------------}
    FIcon: TIconSequence;
    procedure OnIconChange(Sender: TObject);
  protected
    function ChangeProperties: Boolean; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    property Icon: TIconSequence read FIcon write FIcon;
  end;

  {*------------------------------------------------------------------------------
    FMX class for polylines collection.
  -------------------------------------------------------------------------------}
  {=------------------------------------------------------------------------------
    Clase FMX para la colecci�n de polil�neas.
  -------------------------------------------------------------------------------}
  TPolylines = class(TBasePolylines)
  private
    procedure SetItems(I: Integer; const Value: TPolyline);
    function GetItems(I: Integer): TPolyline;
  protected
    function GetOwner: TPersistent; override;
  public
    function Add: TPolyline;
    function Insert(Index: Integer): TPolyline;

    {*------------------------------------------------------------------------------
      Lists the rectangles in the collection.
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Lista de rect�ngulos en la colecci�n.
    -------------------------------------------------------------------------------}
    property Items[I: Integer]: TPolyline read GetItems write SetItems; default;
  end;

  {*------------------------------------------------------------------------------
    FMX class for GMPolyline component.
    More information at https://developers.google.com/maps/documentation/javascript/reference?hl=en#Polyline
  -------------------------------------------------------------------------------}
  {=------------------------------------------------------------------------------
    Clase FMX para el componente GMPolyline.
    M�s informaci�n en https://developers.google.com/maps/documentation/javascript/reference?hl=en#Polyline
  -------------------------------------------------------------------------------}
  TGMPolyline = class(TGMBasePolyline)
  private
    {*------------------------------------------------------------------------------
      This event is fired when the polyline's Icon property are changed.
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Este evento ocurre cuando cambia la propiedad Icon de una polil�nea.
    -------------------------------------------------------------------------------}
    FOnIconChange: TLinkedComponentChange;
  protected
    function GetAPIUrl: string; override;

    function GetItems(I: Integer): TPolyline;

    procedure ShowElements; override;
    function GetCollectionItemClass: TLinkedComponentClass; override;
    function GetCollectionClass: TLinkedComponentsClass; override;
  public
    function Add: TPolyline;

    {*------------------------------------------------------------------------------
      Array with the collection items.
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Array con la colecci�n de elementos.
    -------------------------------------------------------------------------------}
    property Items[I: Integer]: TPolyline read GetItems; default;
  published
    property OnIconChange: TLinkedComponentChange read FOnIconChange write FOnIconChange;
  end;

implementation

uses
  System.SysUtils,

  GMFunctionsFMX, GMConstants;

{ TSymbol }

procedure TSymbol.Assign(Source: TPersistent);
begin
  inherited;

  if Source is TSymbol then
  begin
    FillColor := TSymbol(Source).FillColor;
    StrokeColor := TSymbol(Source).StrokeColor;
  end;
end;

constructor TSymbol.Create;
begin
  inherited;

  FFillColor := TAlphaColorRec.Red;
  FStrokeColor := TAlphaColorRec.Red;
end;

function TSymbol.GetFillColor: string;
begin
  Result := TTransform.TColorToStr(FFillColor);
end;

function TSymbol.GetStrokeColor: string;
begin
  Result := TTransform.TColorToStr(FStrokeColor);
end;

procedure TSymbol.SetFillColor(const Value: TAlphaColor);
begin
  if FFillColor = Value then Exit;

  FFillColor := Value;
  if Assigned(OnChange) then OnChange(Self);
end;

procedure TSymbol.SetStrokeColor(const Value: TAlphaColor);
begin
  if FStrokeColor = Value then Exit;

  FStrokeColor := Value;
  if Assigned(OnChange) then OnChange(Self);
end;

{ TIconSequence }

constructor TIconSequence.Create(aOwner: TBasePolyline);
begin
  inherited;

  Icon := TSymbol.Create;
  TSymbol(Icon).OnChange := OnIconChange;
end;

{ TBasePolylineFMX }

procedure TBasePolylineFMX.Assign(Source: TPersistent);
begin
  inherited;

  if Source is TBasePolylineFMX then
  begin
    StrokeColor := TBasePolylineFMX(Source).StrokeColor;
  end;
end;

constructor TBasePolylineFMX.Create(Collection: TCollection);
begin
  inherited;

  FStrokeColor := TAlphaColorRec.Black;
end;

function TBasePolylineFMX.GetStrokeColor: string;
begin
  Result := TTransform.TColorToStr(FStrokeColor);
end;

procedure TBasePolylineFMX.SetStrokeColor(const Value: TAlphaColor);
begin
  if FStrokeColor = Value then Exit;

  FStrokeColor := Value;

  ChangeProperties;
  if Assigned(TGMPolyline(TPolylines(Collection).FGMLinkedComponent).OnStrokeColorChange) then
    TGMBasePolyline(TPolylines(Collection).FGMLinkedComponent).OnStrokeColorChange(
                  TGMPolyline(TPolylines(Collection).FGMLinkedComponent),
                  Index,
                  Self);
end;

{ TPolyline }

procedure TPolyline.Assign(Source: TPersistent);
begin
  inherited;

  if Source is TPolyline then
  begin
    Icon.Assign(TPolyline(Source).Icon);
  end;
end;

function TPolyline.ChangeProperties: Boolean;
const
  StrParams = '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s';
var
  Params: string;
  DistRepeat: string;
  Offset: string;
begin
  inherited;

  Result := False;

  if not Assigned(Collection) or not(Collection is TPolylines) or
     not Assigned(TPolylines(Collection).FGMLinkedComponent) or
     not TGMPolyline(TPolylines(Collection).FGMLinkedComponent).AutoUpdate or
     not Assigned(TGMPolyline(TPolylines(Collection).FGMLinkedComponent).Map) or
     (csDesigning in TGMPolyline(TPolylines(Collection).FGMLinkedComponent).ComponentState) then
    Exit;

  case Icon.DistRepeat.Measure of
    mPixels: DistRepeat := IntToStr(Icon.DistRepeat.Value) + 'px';
    else DistRepeat := IntToStr(Icon.DistRepeat.Value) + '%';
  end;

  case Icon.OffSet.Measure of
    mPixels: Offset := IntToStr(Icon.OffSet.Value) + 'px';
    else Offset := IntToStr(Icon.OffSet.Value) + '%';
  end;

  Params := Format(StrParams, [
                  IntToStr(IdxList),
                  IntToStr(Index),
                  LowerCase(TTransform.GMBoolToStr(Clickable, True)),
                  LowerCase(TTransform.GMBoolToStr(Editable, True)),
                  LowerCase(TTransform.GMBoolToStr(Geodesic, True)),
                  QuotedStr(GetStrokeColor),
                  StringReplace(FloatToStr(StrokeOpacity), ',', '.', [rfReplaceAll]),
                  IntToStr(StrokeWeight),
                  LowerCase(TTransform.GMBoolToStr(Visible, True)),
                  QuotedStr(PolylineToStr),
                  QuotedStr(InfoWindow.GetConvertedString),
                  LowerCase(TTransform.GMBoolToStr(InfoWindow.DisableAutoPan, True)),
                  IntToStr(InfoWindow.MaxWidth),
                  IntToStr(InfoWindow.PixelOffset.Height),
                  IntToStr(InfoWindow.PixelOffset.Width),
                  LowerCase(TTransform.GMBoolToStr(InfoWindow.CloseOtherBeforeOpen, True)),
                  QuotedStr(DistRepeat),
                  QuotedStr(TSymbol(Icon.Icon).GetFillColor),
                  StringReplace(FloatToStr(Icon.Icon.FillOpacity), ',', '.', [rfReplaceAll]),
                  QuotedStr(TTransform.SymbolPathToStr(Icon.Icon.Path)),
                  QuotedStr(TSymbol(Icon.Icon).GetStrokeColor),
                  StringReplace(FloatToStr(Icon.Icon.StrokeOpacity), ',', '.', [rfReplaceAll]),
                  IntToStr(Icon.Icon.StrokeWeight),
                  QuotedStr(Offset)
                  ]);

  Result := TGMPolyline(TPolylines(Collection).FGMLinkedComponent).ExecuteScript('MakePolyline', Params);
  TGMPolyline(TPolylines(Collection).FGMLinkedComponent).ErrorControl;
end;

constructor TPolyline.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FIcon := TIconSequence.Create(Self);
  FIcon.OnChange := OnIconChange;
end;

destructor TPolyline.Destroy;
begin
  if Assigned(FIcon) then FreeAndNil(FIcon);

  inherited;
end;

procedure TPolyline.OnIconChange(Sender: TObject);
begin
  if ChangeProperties and Assigned(TGMPolyline(TPolylines(Collection).FGMLinkedComponent).FOnIconChange) then
    TGMPolyline(TPolylines(Collection).FGMLinkedComponent).FOnIconChange(
                  TGMPolyline(TPolylines(Collection).FGMLinkedComponent),
                  Index,
                  Self);
end;

{ TPolylines }

function TPolylines.Add: TPolyline;
begin
  Result := TPolyline(inherited Add);
end;

function TPolylines.GetItems(I: Integer): TPolyline;
begin
  Result := TPolyline(inherited Items[I]);
end;

function TPolylines.GetOwner: TPersistent;
begin
  Result := TGMPolyline(inherited GetOwner);
end;

function TPolylines.Insert(Index: Integer): TPolyline;
begin
  Result := TPolyline(inherited Insert(Index));
end;

procedure TPolylines.SetItems(I: Integer; const Value: TPolyline);
begin
  inherited SetItem(I, Value);
end;

{ TGMPolyline }

function TGMPolyline.Add: TPolyline;
begin
  Result := TPolyline(inherited Add);
end;

function TGMPolyline.GetAPIUrl: string;
begin
  Result := 'https://developers.google.com/maps/documentation/javascript/reference?hl=en#Polyline';
end;

function TGMPolyline.GetCollectionClass: TLinkedComponentsClass;
begin
  Result := TPolylines;
end;

function TGMPolyline.GetCollectionItemClass: TLinkedComponentClass;
begin
  Result := TPolyline;
end;

function TGMPolyline.GetItems(I: Integer): TPolyline;
begin
  Result := TPolyline(inherited Items[i]);
end;

procedure TGMPolyline.ShowElements;
var
  i: Integer;
begin
  if not ExecuteScript('DeleteObjects', IntToStr(IdxList)) then Exit;

  for i:= 0 to VisualObjects.Count - 1 do
    Items[i].ChangeProperties;
end;

end.