program ejercicio10;
const
    cantSuc=8;
    valoralto=32767;
type
    Producto = record
        codigo:Integer;
        nombre_comercial:String;
        descripcion:String;
        precio:Double;
        cantidad:Integer;
        mayor_mes:Integer;
    end;

    Venta = record
        codigo:Integer;
        cantidad:Integer;
    end;

    archProducto = file of Producto;
    archVenta = file of Venta;
    arrArchVenta = array[1..cantSuc] of archVenta;
    arrVenta = array[1..cantSuc] of Venta;

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

procedure generarMaestroyDetalles(var maestro:archProducto; var detalles:arrArchVenta);
var
    textoM:Text;
    textoD:Text;
    i:Integer;
    str:String;
    prod:Producto;
    vent:Venta;
begin
    Assign(textoM,'maestro.txt');
    Reset(textoM);
    Assign(textoD,'detalles.txt');
    Reset(textoD);
    Assign(maestro,'maestro.dat');
    Rewrite(maestro);
    for i:=1 to cantSuc do begin
        IntegertoString(str,i);
        str:='Detalle'+str+'.dat';
        Assign(detalles[i],str);
        Rewrite(detalles[i]);
    end;
    while (not Eof(textoM)) do begin
        ReadLn(textoM,prod.codigo);
        ReadLn(textoM,prod.nombre_comercial);
        ReadLn(textoM,prod.descripcion);
        ReadLn(textoM,prod.precio);
        ReadLn(textoM,prod.cantidad);
        ReadLn(textoM,prod.mayor_mes);
        Write(maestro,prod);
    end;
    i:=1;
    while (not Eof(textoD)) do begin
        ReadLn(textoD,vent.codigo);
        ReadLn(textoD,vent.cantidad);
        Write(detalles[i],vent);
        i:=i+1;
        if (i > cantSuc) then
          i:=1;
    end;
    Close(textoM);
    Close(textoD);
end;

procedure leer(var archV:ArchVenta; var regV:Venta);
begin
    if (not eof(archV)) then begin
        Read(archV,regV);
    end else begin
        regV.codigo:=valoralto;
    end;
end;

procedure minimo(var detalles:arrArchVenta; var min:Venta; var arrV:arrVenta);
var
    i,pos:Integer;
begin
    min:=arrV[1];
    pos:=1;
    for i:=2 to cantSuc do begin
        if (arrV[i].codigo < min.codigo) then begin
            min:=arrV[i];
            pos:=i;
        end;
    end;
    leer(detalles[pos],arrV[pos]);
end;

procedure actualizarMaestro(var maestro:archProducto; var detalles:arrArchVenta);
var
    arrV:arrVenta;
    min,aux:Venta;
    prod:Producto;
    i:Integer;
begin
    Reset(maestro);
    for i:=1 to cantSuc do begin
        Reset(detalles[i]);
        leer(detalles[i],arrV[i]);
    end;
    minimo(detalles,min,arrV);
    Read(maestro,prod);
    while (min.codigo <> valoralto) do begin
        while (prod.codigo <> min.codigo) do begin
            Read(maestro,prod);
        end;
        prod.cantidad:=0;
        aux:=min;
        while (aux.codigo = min.codigo) do begin
            prod.cantidad:=prod.cantidad+min.cantidad;
            minimo(detalles,min,arrV);
        end;
        if (prod.cantidad > prod.mayor_mes) then begin
            WriteLn(prod.codigo,' ',prod.nombre_comercial,' Mes anterior:',prod.mayor_mes,' Mes actual:',prod.cantidad,'.');
            prod.mayor_mes:=prod.cantidad;
        end;
        Seek(maestro,FilePos(maestro)-1);
        Write(maestro,prod);
    end;

end;

var
    maestro:archProducto;
    detalles:arrArchVenta;
    prod:Producto;
    i:Integer;
begin
    generarMaestroyDetalles(maestro,detalles);
    actualizarMaestro(maestro,detalles);
    Reset(maestro);
    WriteLn('-------------------------------------------------');
    while (not Eof(maestro)) do begin
        Read(maestro,prod);
        WriteLn(prod.codigo,' ',prod.cantidad,' ',prod.mayor_mes);
    end;
    Close(maestro);
    for i:=1 to cantSuc do begin
        Close(detalles[i]);
    end;
end.