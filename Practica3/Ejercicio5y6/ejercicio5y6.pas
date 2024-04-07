program ejercicio5y6;
const
    marca=-1;
type
    Articulo = record
        nroArt:Integer;
        descripcion:String;
        color:String;
        talle:String[3];
        stock:Integer;
        precio:Double;
    end;

    archArticulos = file of Articulo;


procedure generarMaestro(var maestro:archArticulos);
var
    archT:Text;
    art:Articulo;
begin
    Assign(archT,'Articulos.txt');
    Reset(archT);
    Rewrite(maestro);
    while (not Eof(archT)) do begin
        ReadLn(archT,art.nroArt);
        ReadLn(archT,art.descripcion);
        ReadLn(archT,art.color);
        ReadLn(archT,art.talle);
        ReadLn(archT,art.stock);
        ReadLn(archT,art.precio);
        Write(maestro,art);
    end;
    Close(archT);
end;

procedure imprimir(var maestro:archArticulos);
var
    art:Articulo;
begin
    Reset(maestro);
    while (not Eof(maestro)) do begin
        Read(maestro,art);
        WriteLn(art.nroArt,' ',art.descripcion,' ',art.color,' ',art.talle,' ',art.stock,' $',art.precio);
    end;
end;

procedure actualizarMaestro(var maestro:archArticulos);
var
    archT:Text;
    art:Articulo;
    cod:Integer;
begin
    Assign(archT,'Articulos_eliminados.txt');
    Rewrite(archT);
    Write('Codigo de articulo a eliminar(0 para salir):');
    Read(cod);
    while (cod <> 0) do begin
        Reset(maestro);
        Read(maestro,art);
        while ((not Eof(maestro)) and (art.nroArt < cod)) do begin
            Read(maestro,art);
        end;
        if (art.nroArt = cod)then begin
            WriteLn(archT,art.nroArt,' ',art.descripcion,' ',art.color,' ',art.talle,' ',art.stock,' $',art.precio);
            art.nroArt := marca;
            Seek(maestro,FilePos(maestro)-1);
            Write(maestro,art);
        end;
        Write('Codigo de articulo a eliminar(0 para salir):');
        Read(cod);
    end;
    Close(archT);
end;

procedure compactar(var maestro:archArticulos);
var
    copia:archArticulos;
    art:Articulo;
begin
    Assign(copia,'ArticulosCopia.dat');
    Rewrite(copia);
    Reset(maestro);
    while (not Eof(maestro)) do begin
        Read(maestro,art);
        if (art.nroArt <> marca) then begin
            Write(copia,art);
        end;
    end;
    Close(copia);
    Close(maestro);
    Erase(maestro);
    Rename(copia,'Articulos.dat');
end;


var
    maestro:archArticulos;
begin
    Assign(maestro,'Articulos.dat');
    generarMaestro(maestro);
    imprimir(maestro);
    actualizarMaestro(maestro);
    imprimir(maestro);
    compactar(maestro);
    WriteLn('----------------------------------------------------------');
    imprimir(maestro);
end.