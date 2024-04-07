program ejercicio7;

type
    Persona= Record
        DNI:integer;
        nombre: String;
        apellido:String;
        sueldo:Double;
    end;
    tArchivo = File of Persona;

procedure crear(var arch:tArchivo; var info:Text);
var
    pers:Persona;
begin
    Reset(info);
    Rewrite(arch);
    pers.DNI:=0;
    pers.nombre:='';
    pers.apellido:='';
    pers.sueldo:=0;
    Write(arch,pers);
    while (not Eof(info)) do begin
        ReadLn(info,pers.DNI);
        ReadLn(info,pers.nombre);
        ReadLn(info,pers.apellido);
        ReadLn(info,pers.sueldo);
        Write(arch,pers);
    end;
end;

procedure imprimir(var arch:tArchivo);
var
    pers:Persona;
begin
    WriteLn('-----------------------------------------------------');
    Reset(arch);
    while (not Eof(arch)) do begin
        Read(arch,pers);
        WriteLn(pers.DNI,' ',pers.nombre,' ',pers.apellido,' ',pers.sueldo);
    end;
end;

procedure agregar(var arch: tArchivo; p: persona);
var
    pLibre:Persona;
    nLibre:Integer;
begin
    Reset(arch);
    Read(arch,pLibre);
    if (pLibre.DNI <> 0) then begin
        nLibre:=pLibre.DNI*(-1);
        Seek(arch,nLibre);
        Read(arch,pLibre);
        Seek(arch,nLibre);
        Write(arch,p);
        Seek(arch,0);
        Write(arch,pLibre);
    end else begin
        Seek(arch,FileSize(arch));
        Write(arch,p);
    end;
end;


procedure eliminar(var arch: tArchivo; DNI: integer);
var
    pLibre,aux:Persona;
    nLibre:Integer;
begin
    Reset(arch);
    Read(arch,pLibre);
    Read(arch,aux);
    while ((not Eof(arch)) and (aux.DNI<>DNI)) do begin
        Read(arch,aux);
    end;
    if (aux.DNI=DNI) then begin
        nLibre:=FilePos(arch)-1;
        Seek(arch,nLibre);
        Write(arch,pLibre);
        Seek(arch,0);
        aux.DNI:=nLibre*(-1);
        Write(arch,aux);
    end else begin
        WriteLn('No existe persona con el DNI ',DNI,'.');
    end;
end;





var
    arch:tArchivo;
    info:Text;
    p:Persona;
begin
    Assign(arch,'empleados.dat');
    Assign(info,'empleados.txt');
    crear(arch,info);
    imprimir(arch);
    eliminar(arch,13);
    eliminar(arch,15);
    eliminar(arch,23);
    imprimir(arch);
    p.DNI:=777;
    p.nombre:='777777';
    p.apellido:='777777';
    p.sueldo:=777.777;
    agregar(arch,p);
    imprimir(arch);
end.