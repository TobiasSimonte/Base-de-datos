Program ejercicio5;

Type
    especiesFlores=record
        nroEspecie:Integer;
        alturaMax:Integer;
        nombreCientifico:String[50];
        nombreBulgar:String[50];
        color:String[50];
    end;
    tArchivoEspecies = file of especiesFlores;

procedure leerEspecie(var especie:especiesFlores);
begin
    WriteLn('Nro de especie:');
    ReadLn(especie.nroEspecie);
    WriteLn('Altura maxima:');
    ReadLn(especie.alturaMax);
    WriteLn('Nombre cientifico:');
    ReadLn(especie.nombreCientifico);
    WriteLn('Nombre bulgar:');
    ReadLn(especie.nombreBulgar);
    WriteLn('Color');
    ReadLn(especie.color);

end;

procedure Opciones;
begin
    WriteLn('Opciones:');
    WriteLn('0:Salir');
    WriteLn('1:Reporte');
    WriteLn('2:Listar');
    WriteLn('3:Modificar');
    WriteLn('4:Añadir');
    WriteLn('5:Crear archivo Txt');
end;

procedure Reporte(var arch:tArchivoEspecies);
var
    cant,min,max:Integer;
    especieMax,especieMin:String[50];
    especie:especiesFlores;
begin
    Reset(arch);
    cant:=0;
    min:=9999;
    max:=0;
    while (not eof(arch)) do begin
        cant:=cant+1;
        Read(arch,especie);
        if (especie.alturaMax > max) then begin
            max:=especie.alturaMax;
            especieMax:=especie.nombreCientifico;
        end;
        if (especie.alturaMax < min) then begin
            min:=especie.alturaMax;
            especieMin:=especie.nombreCientifico;
        end;
    end;
    WriteLn('Cantidad:',cant,' Especie maxima altura:',especieMax,' Especie minima altura:',especieMin,'.');
end;

procedure Listar(var arch:tArchivoEspecies);
var
    especie:especiesFlores;
begin
    Reset(arch);
    while (not eof(arch)) do begin
        Read(arch,especie);
        WriteLn(especie.nroEspecie,' ',especie.alturaMax,' ',especie.nombreCientifico,' ',especie.nombreBulgar,' ',especie.color,'.')
    end;
end;

procedure Modificar(var arch:tArchivoEspecies);
var
    pos:Integer;
    especie:especiesFlores;
begin
    Reset(arch);
    especie.nombreCientifico:=' ';
    pos:=FilePos(arch);
    while (not eof(arch) and (especie.nombreCientifico <> 'Victoria amazónica')) do begin
        Read(arch,especie);
        if (especie.nombreCientifico='Victoria amazonia') then begin
            Seek(arch,pos);
            especie.nombreCientifico:='Victoria amazónica';
            Write(arch,especie);
        end;
        Pos:=FilePos(arch);
    end;
end;

procedure Aniadir(var arch:tArchivoEspecies);
var
    especie:especiesFlores;
begin
    Reset(arch);
    Seek(arch,FileSize(arch));
    leerEspecie(especie);
    while (especie.nombreCientifico <> 'zzz') do begin
        Write(arch,especie);
        leerEspecie(especie);
    end;
end;

procedure CrearTxt(var arch:tArchivoEspecies);
var
    especie:especiesFlores;
    archT:Text;
begin
    Assign(archT,'flores.txt');
    Reset(arch);
    Rewrite(archT);
    while (not eof(arch)) do begin
        Read(arch,especie);
        WriteLn(archT,especie.nroEspecie,especie.alturaMax,especie.nombreCientifico);
        WriteLn(archT,especie.nombreBulgar);
        WriteLn(archT,especie.color);
    end;
    Close(archT);
end;

Var
    arch: tArchivoEspecies;
    especie:especiesFlores;
    opc:Integer;
Begin
    Assign(arch,'Tipo de especies');
    Rewrite(arch);
    leerEspecie(especie);
    while(especie.nombreCientifico <> 'zzz') do begin
        Write(arch,especie);
        leerEspecie(especie);
    end;
    repeat
        Opciones;
        ReadLn(opc);
        case opc of 
            1:Reporte(arch);
            2:Listar(arch);
            3:Modificar(arch);
            4:Aniadir(arch);
            5:CrearTxt(arch);
        end;  
    until (opc=0);
    Close(arch);
end.


