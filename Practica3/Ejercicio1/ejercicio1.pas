program ejercicio1;
const
    marca=-1;
type
    especie = record
        codigo:LongInt;
        nombre_vulgar:String;
        nombre_cientifico:String;
        alturaProm:Integer;
        descripcion:String;
        zona:String;
    end;

    archEspecies = file of especie;

procedure generarArchivo(var especies:archEspecies);
var
    archT:Text;
    esp:especie;
begin
    Assign(archT,'especies.txt');
    Reset(archT);
    Rewrite(especies);
    while (not eof(archT)) do begin
        ReadLn(archT,esp.codigo);
        ReadLn(archT,esp.nombre_vulgar);
        ReadLn(archT,esp.nombre_cientifico);
        ReadLn(archT,esp.alturaProm);
        ReadLn(archT,esp.descripcion);
        ReadLn(archT,esp.zona);
        Write(especies,esp);
    end;
    Close(archT);
end;


procedure borrarConMarcar(var especies:archEspecies);
Var
    cod:LongInt;
    esp:especie;
    especiesBorrado:archEspecies;
begin
    Write('Codigo:');
    Read(cod);
    while (cod <> 100000) do begin
        Reset(especies);
        esp.codigo:=100000;
        while ((not eof(especies)) and (esp.codigo <> cod)) do begin
            Read(especies,esp);
        end;
        if (esp.codigo = cod) then begin
            esp.codigo:=marca;
            Seek(especies,FilePos(especies)-1);
            Write(especies,esp);
            WriteLn('Elemento borrado con exito.');
        end else begin
            WriteLn('No se encontro elemento');
        end;
        Write('Codigo:');
        Read(cod);
    end;
    Reset(especies);
    Assign(especiesBorrado,'especiesBorrado.dat');
    Rewrite(especiesBorrado);
    while (not Eof(especies)) do begin
        Read(especies,esp);
        if (esp.codigo <> marca) then begin
            Write(especiesBorrado,esp);
        end;
    end;
    Close(especiesBorrado);
end;

procedure borrarReemplazandoUltimo(var especies:archEspecies);
Var
    cod:LongInt;
    esp:especie;
    posBorrar:LongInt;
begin
    Write('Codigo:');
    Read(cod);
    while (cod <> 100000) do begin
        Reset(especies);
        esp.codigo:=100000;
        while ((not eof(especies)) and (esp.codigo <> cod)) do begin
            Read(especies,esp);
        end;
        if (esp.codigo = cod) then begin
            posBorrar:=FilePos(especies)-1;
            Seek(especies,FileSize(especies)-1);
            Read(especies,esp);
            Seek(especies,posBorrar);
            Write(especies,esp);
            Seek(especies,FileSize(especies)-1);
            Truncate(especies);
            WriteLn('Elemento borrado con exito.');
        end else begin
            WriteLn('No se encontro elemento');
        end;
        Write('Codigo:');
        Read(cod);
    end;
end;


var
    especies,especiesBorrado:archEspecies;
    esp:especie;
begin
    Assign(especies,'especies.dat');
    generarArchivo(especies);
    borrarConMarcar(especies);
    //borrarReemplazandoUltimo(especies);
    Reset(especies);
    while (not Eof(especies)) do begin
        Read(especies,esp);
        WriteLn(esp.codigo);
    end;
    Close(especies);
end.