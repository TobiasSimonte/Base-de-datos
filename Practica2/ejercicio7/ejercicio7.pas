program ejercicio7;
const
    cantArchVentas=10;
    valoralto=32767;
type
    Producto = record
        codigo: integer;
        nombreComercial: string;
        descripcion: string;
        precio: real;
        stock: integer;
        stockMinimo: integer;
    end;

    Venta = record
        codigo: integer;
        unidades: integer;
    end;

    archProducto = file of Producto;
    archVenta = file of Venta;
    arrVenta = array[1..cantArchVentas] of archVenta;
    arrRVenta = array[1..cantArchVentas] of Venta;

procedure IntegertoString(var str:String; int:Integer);
var
    i:Integer;
    c:Char;
begin
    str:='';
    while (int <> 0) do begin
        i:= int mod 10;
        int := int div 10;
        c:=Char(i+48);
        str:=c+str;
    end;
end;

procedure gererarDetalles(var ventas:arrVenta);
var
    detT:Text;
    i:Integer;
    str:String;
    vta:Venta;
begin
    Assign(detT,'detalles.txt');
    Reset(detT);
    for i:=1 to cantArchVentas do begin
        IntegertoString(str,i);
        str:='Detalle'+str+'.dat';
        Assign(ventas[i],str);
        Rewrite(ventas[i]);
    end;
    i:=1;
    while (not eof(detT)) do begin
        ReadLn(detT,vta.codigo);
        ReadLn(detT,vta.unidades);
        Write(ventas[i],vta);
        i:=i+1;
        if (i = (cantArchVentas+1)) then
          i:=1;
    end;
    Close(detT);
    for i:=1 to cantArchVentas do begin
        Reset(ventas[i]);
    end;
end;

procedure imprimirOpc;
begin
    WriteLn('1.Crear archivo maestro.');
    WriteLn('2.Actualizar archivo maestro.');
    Write('Opcion:');
end;

procedure imprimirMaestro(var maestro:archProducto);
var
    prod:Producto;
begin
    Reset(maestro);
    while (not Eof(maestro)) do begin
        Read(maestro,prod);
        WriteLn(prod.codigo,' $',prod.precio,' Stock:',prod.stock);
    end;
end;

procedure crearMaestro(var maestro:archProducto);
var
    archT:Text;
    prod:Producto;
begin
    Assign(archT,'productos.txt');
    Reset(archT);
    Reset(maestro);
    while (not eof(archT)) do begin
        ReadLn(archT,prod.codigo);
        ReadLn(archT,prod.nombreComercial);
        ReadLn(archT,prod.descripcion);
        ReadLn(archT,prod.precio);
        ReadLn(archT,prod.stock);
        ReadLn(archT,prod.stockMinimo);
        Write(maestro,prod);
    end;
    Close(archT);
end;

procedure leer(var venta:archVenta; var regV:Venta);
begin
    if (not eof(venta)) then begin
        Read(venta,regV);
    end else begin
        regV.codigo:=valoralto;
    end;
end;

procedure minimo(var ventas:arrVenta; var min:Venta; var arrRVentas:arrRVenta);
var
    i,pos:integer;
begin
    min:=arrRVentas[1];
    pos:=1;
    for i:=2 to cantArchVentas do begin
        if (arrRVentas[i].codigo < min.codigo) then begin
            pos:=i;
            min:=arrRVentas[i];
        end;
    end;
    leer(ventas[pos],arrRVentas[pos]);
end;

procedure actualizarMaestro(var maestro:archProducto;var ventas:arrVenta);
var
    arrRVentas:arrRVenta;
    min,aux:Venta;
    regM:Producto;
    i:Integer;
begin
    Reset(maestro);
    for i:=1 to cantArchVentas do begin
        Reset(ventas[i]);
        leer(ventas[i],arrRVentas[i]);
    end;
    minimo(ventas,min,arrRVentas);
    Read(maestro,regM);
    while (min.codigo <> valoralto) do begin
        while (regM.codigo <> min.codigo) do begin
            Read(maestro,regM);
        end;
        aux:=min;
        while (min.codigo = aux.codigo) do begin
            regM.stock:=regM.stock-min.unidades;
            minimo(ventas,min,arrRVentas);
        end;
        Seek(maestro,FilePos(maestro)-1);
        Write(maestro,regM);
    end;

end;


var
    opc:Integer;
    maestro:archProducto;
    detalles:arrVenta;
    opc1elegida:Boolean;
begin
    gererarDetalles(detalles);
    Assign(maestro,'maestro.dat');
    Rewrite(maestro);
    opc1elegida:=False;
    repeat
        imprimirOpc;
        ReadLn(opc);
        if (opc = 1) then begin
            crearMaestro(maestro);
            opc1elegida:=True;
            imprimirMaestro(maestro);
        end;
        if ((opc = 2) and opc1elegida) then
            actualizarMaestro(maestro,detalles);
    until ((opc <> 1) and (opc <> 2));
    imprimirMaestro(maestro);
end.