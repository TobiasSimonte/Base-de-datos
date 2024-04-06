program ejercicio4;
type
    Disco = record
        codigo:Integer;
        nombre:String[40];
        genero:String[20];
        artista:String[30];
        descripcion:String;
        anio:Integer;
        stock:Integer;
    end;

    archDiscos = file of Disco;

procedure generarArchivo(var discos:archDiscos);
var
    archT:Text;
    disc:Disco;
begin
    Assign(archT,'Discos.txt');
    Reset(archT);
    ReWrite(discos);
    while (not eof(archT)) do begin
        ReadLn(archT,disc.codigo);
        ReadLn(archT,disc.nombre);
        ReadLn(archT,disc.genero);
        ReadLn(archT,disc.artista);
        ReadLn(archT,disc.descripcion);
        ReadLn(archT,disc.anio);
        ReadLn(archT,disc.stock);
        Write(discos,disc);
    end;
end;

procedure modificarStock(var discos:archDiscos);
var
    cd:Disco;
    codigo:Integer;
begin
    WriteLn('Codigo de disco sin stock(0 para salir):');
    Read(codigo);
    while (codigo <> 0) do begin
        Reset(discos);
        cd.codigo:=0;
        while ((not eof(discos)) and (cd.codigo <> codigo)) do begin
            Read(discos,cd);
        end;
        if (cd.codigo = codigo) then begin
            cd.stock:=0;
            Seek(discos,FilePos(discos)-1);
            Write(discos,cd);
            WriteLn('El album ',cd.nombre,' se quedo sin stock.');
        end;
        WriteLn('Codigo de disco sin stock(0 para salir):');
        Read(codigo);
    end;
end;

procedure imprimir(var discos:archDiscos);
var
   cd:Disco;
begin
    Reset(discos);
    while (not eof(discos)) do begin
        Read(discos,cd);
        WriteLn(cd.codigo,' ',cd.nombre,' ',cd.stock,'.');
    end;
end; 

procedure compactacion(var discos:archDiscos);
var
    discos2:archDiscos;
    cd:Disco;
begin
    Assign(discos2,'discos2.dat');
    Rewrite(discos2);
    Reset(discos);
    while (not eof(discos)) do begin
        Read(discos,cd);
        if (cd.stock <> 0) then
          Write(discos2,cd);
    end;
    Close(discos);
    Erase(discos);
    Close(discos2);
    Rename(discos2,'discos.dat');
end;


var
    discos:archDiscos;
begin
    Assign(discos,'discos.dat');
    generarArchivo(discos);
    imprimir(discos);
    modificarStock(discos);
    imprimir(discos);
    compactacion(discos);
    WriteLn('--------------------------');
    imprimir(discos);
end.