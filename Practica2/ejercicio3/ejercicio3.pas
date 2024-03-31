program ejercicio3;
const
    valoralto=9999;
type
    Calzado = record
        codigo: integer;
        numero: integer;
        descripcion: string;
        precio_unitario: Real;
        color: string;
        stock: integer;
        stock_minimo: integer;
    end;

    Venta = record
        codigo: integer;
        numero: integer;
        cantidad_vendida: integer;
    end;

    ArchivoCalzado = file of Calzado;
    ArchivoVenta = file of Venta;
    ArchivosVenta = array[1..20] of ArchivoVenta;

procedure leer(var archivo_venta:ArchivoVenta; var vta:Venta);
begin
    if (not Eof(archivo_venta)) then begin
        Read(archivo_venta,vta);
    end else begin
        vta.codigo:=valoralto;
        vta.numero:=valoralto;
    end;
end;

procedure minimo(var archivos_venta: ArchivosVenta; var min:Venta; var ventas:array[1..20] of Venta);
var
    i:Integer;
    pos:Integer;
begin
    min:=ventas[1];
    pos:=1;
    for i:=2 to 20 do begin
        if (ventas[i].codigo<=min.codigo) then begin
            if(ventas[i].numero<=min.numero) then begin
                min:=ventas[i];
                pos:=i;
            end;
        end;
    end;
    leer(archivos_venta[pos],ventas[pos]);
end;


procedure actualizar_stock(var archivo_calzado: ArchivoCalzado; var archivos_venta: ArchivosVenta);
var
    calzado: Calzado;
    ventas: array[1..20] of Venta;
    i: integer;
    min: Venta;
    aux: Venta;
    calzadosDebajoStock: Text;
begin
    Assign(calzadosDebajoStock,'CalzadosDebajoStock.txt');
    Rewrite(calzadosDebajoStock);
    Reset(archivo_calzado);
    for i:=1 to 20 do begin
        Reset(archivos_venta[i]);
    end;
    Read(archivo_calzado,calzado);
    for i:=1 to 20 do begin
        leer(archivos_venta[i],ventas[i]);
    end;
    minimo(archivos_venta,min,ventas);
    while (min.codigo <> valoralto) do begin
        while (calzado.codigo<>min.codigo or calzado.numero<>min.numero) do begin
            WriteLn(calzado.codigo,' ',calzado.numero,' $',calzado.precio_unitario,'.');
            Read(archivo_calzado,calzado);
        end;
        aux:=min;
        while (aux.codigo=min.codigo and aux.numero=min.numero) do begin
            calzado.stock:=calzado.stock-min.cantidad_vendida;
            minimo(archivos_venta,min,ventas);
        end;
        if (calzado.stock < calzado.stock_minimo) then
            WriteLn(calzadosDebajoStock,calzado.codigo,' ',calzado.numero,' $',calzado.precio_unitario,' Stock:',calzado.stock,' StockMinimo:'calzado.stock_minimo,'.');
        Seek(archivo_calzado,Pos(archivo_calzado)-1);
        Write(archivo_calzado,calzado);
    end;
end;


var
    archivo_calzado: ArchivoCalzado;
    archivos_venta: ArchivosVenta;
    calzado: Calzado;
    venta: Venta;
begin
    
end.