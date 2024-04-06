program ejercicio3;
type
    producto = record
        codigo:Integer;
        nombre:String[30];
        descripcion:String;
        stock:Integer;
    end;

    arch_productos = file of producto;

procedure imprimirSinLista(var productos:arch_productos);
var
    prod:producto;
begin
    WriteLn('Lista de productos:');
    Reset(productos);
    while (not Eof(productos)) do begin
        Read(productos,prod);
        if (prod.stock <> -1)then
            WriteLn(prod.codigo,' ',prod.nombre,' ',prod.stock);
    end;
end;

procedure imprimirConLista(var productos:arch_productos);
var
    prod:producto;
begin
    WriteLn('Lista de productos:');
    Reset(productos);
    Read(productos,prod); //Descarto la cabecera
    while (not Eof(productos)) do begin
        Read(productos,prod);
        if (prod.stock <> -1)then
            WriteLn(prod.codigo,' ',prod.nombre,' ',prod.stock);
    end;
end;


procedure generarBinarioSinLista(var archT:Text);
var
    productos:arch_productos;
    prod:producto;
begin
    Assign(productos,'Productos.dat');
    Rewrite(productos);
    Reset(archT);
    while (not eof(archT)) do begin
        ReadLn(archT,prod.codigo);
        ReadLn(archT,prod.nombre);
        ReadLn(archT,prod.descripcion);
        ReadLn(archT,prod.stock);
        Write(productos,prod);
    end;
    Close(productos);
end;

procedure generarBinarioConLista(var archT:Text);
var
    productos:arch_productos;
    prod:producto;
begin
    Assign(productos,'Productos.dat');
    Rewrite(productos);
    Reset(archT);
    prod.codigo:=0;
    prod.nombre:='';
    prod.descripcion:='-1';
    prod.stock:=0;
    Write(productos,prod); //Agrego cabecera
    while (not eof(archT)) do begin
        ReadLn(archT,prod.codigo);
        ReadLn(archT,prod.nombre);
        ReadLn(archT,prod.descripcion);
        ReadLn(archT,prod.stock);
        Write(productos,prod);
    end;
    Close(productos);
end;


procedure eliminarSinLista(var productos:arch_productos; cod:Integer);
var
    prod:producto;
begin
    Reset(productos);
    Read(productos,prod);
    while ((not Eof(productos)) and (prod.codigo <> cod)) do begin
        Read(productos,prod);
    end;
    if (prod.codigo = cod) then begin
        prod.stock:=-1;
        Seek(productos,FilePos(productos)-1);
        Write(productos,prod);
    end;
end;

procedure eliminarConLista(var productos:arch_productos; cod:Integer);
var
    prod:producto;
    pLibre:producto;
    nLibre:Integer;
begin
    Reset(productos);
    Read(productos,pLibre);
    Read(productos,prod);
    while ((not Eof(productos)) and (prod.codigo <> cod)) do begin
        Read(productos,prod);
    end;
    if (prod.codigo = cod) then begin
        nLibre:=FilePos(productos)-1;
        pLibre.stock:=-1;
        Seek(productos,nLibre);
        Write(productos,pLibre);
        Seek(productos,0);
        Str(nLibre,prod.descripcion);
        Write(productos,prod);
    end;
end;

procedure agregarSinLista(var productos:arch_productos);
var
    prod:producto;
begin
    WriteLn('Codigo:');
    ReadLn(prod.codigo);
    WriteLn('Nombre:');
    ReadLn(prod.nombre);
    WriteLn('Descripcion:');
    ReadLn(prod.descripcion);
    WriteLn('Stock:');
    ReadLn(prod.stock);
    Seek(productos,FileSize(productos));
    Write(productos,prod);
end;

procedure agregarConLista(var productos:arch_productos);
var
    pLibre,prod:producto;
    nLibre:Integer;
begin
    Reset(productos);
    Read(productos,pLibre);
    Val(pLibre.descripcion,nLibre);
    if (nLibre = -1) then begin
        Seek(productos,FileSize(productos));
    end else begin
        Seek(productos,nLibre);
        Read(productos,pLibre);
        Seek(productos,0);
        Write(productos,pLibre);
        Seek(productos,nLibre);
    end;
    WriteLn('Codigo:');
    ReadLn(prod.codigo);
    WriteLn('Nombre:');
    ReadLn(prod.nombre);
    WriteLn('Descripcion:');
    ReadLn(prod.descripcion);
    WriteLn('Stock:');
    ReadLn(prod.stock);
    Write(productos,prod);
end;


var
    archT:Text;
    productos:arch_productos;
begin
    Assign(archT,'Productos.txt');
    generarBinarioSinLista(archT);
    Assign(productos,'Productos.dat');
    imprimirSinLista(productos);
    eliminarSinLista(productos,1);
    imprimirSinLista(productos);
    agregarSinLista(productos);
    imprimirSinLista(productos);
    Close(productos);
    WriteLn('----------------------------');
    generarBinarioConLista(archT);
    Assign(productos,'Productos.dat');
    imprimirConLista(productos);
    eliminarConLista(productos,1);
    imprimirConLista(productos);
    agregarConLista(productos);
    imprimirConLista(productos);
    agregarConLista(productos);
    imprimirConLista(productos);
    Close(productos);
end.