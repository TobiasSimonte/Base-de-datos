program ejercicio7;
type
    alumno=record
        DNI:LongInt;
        legajo:String[7];
        nombre:String[20];
        apellido:String[20];
        direccion:String[40];
        anio:Integer;
        fechaNac:LongInt;
    end;
    tArchAlumnos= File of alumno;

procedure Opciones;
begin
    WriteLn('Opciones:');
    WriteLn('0:Salir');
    WriteLn('1:Crear Arhivo');
    WriteLn('2:Listar alumnos por caracter');
    WriteLn('3:Crear archivo 5to año');
    WriteLn('4:Añadir alumnos');
    WriteLn('5:Modificar año');
end;

procedure crear(var arch:tArchAlumnos);
var
    archT:Text;
    alu:alumno;
    ch:Char;
begin
    Assign(archT,'alumnos.txt');
    Reset(archT);
    Rewrite(arch);
    while (not eof(archT)) do begin
        ReadLn(archT,alu.DNI,ch,alu.legajo);
        ReadLn(archT,alu.anio,ch,alu.nombre);
        ReadLn(archT,alu.fechaNac,ch,alu.apellido);
        ReadLn(archT,alu.direccion);
        Write(arch,alu);
    end;
    Close(archT);
end;

procedure listar(var arch:tArchAlumnos);
var
    ch:Char;
    alu:alumno;
begin
    Reset(arch);
    Write('Caracter:');
    Read(ch);
    while (not eof(arch)) do begin
        Read(arch,alu);
        if (UpCase(ch)=UpCase(alu.nombre[1])) then
        begin
            WriteLn(alu.DNI,' ',alu.legajo,' ',alu.nombre,' ',alu.apellido,' ',alu.direccion,' ',alu.anio,' ',alu.fechaNac,'.');
        end;
    end;    
end;

procedure alumnos5to(var arch:tArchAlumnos);
var
    alu:alumno;
    archT:Text;
begin
    Assign(archT,'alumnosAEgresar.txt');
    Rewrite(archT);
    Reset(arch);
    while (not eof(arch)) do begin
        Read(arch,alu);
        if(alu.anio=5) then
        begin
            WriteLn(archT,alu.DNI,' ',alu.legajo,' ',alu.nombre,' ',alu.apellido,' ',alu.direccion,' ',alu.anio,' ',alu.fechaNac,'.');
        end;
    end;
    Close(archT);
end;

procedure agregarAlumno(var arch:tArchAlumnos);
var
    alu:alumno;
begin
    Seek(arch,FilePos(arch));
    WriteLn('DNI(0=salir):');
    ReadLn(alu.DNI);
    while (alu.DNI<>0) do begin
        WriteLn('Legajo:');
        ReadLn(alu.legajo);
        WriteLn('Nombre:');
        ReadLn(alu.nombre);
        WriteLn('Apellido:');
        ReadLn(alu.apellido);
        WriteLn('Direccion:');
        ReadLn(alu.direccion);
        WriteLn('Año(1-5):');
        ReadLn(alu.anio);
        WriteLn('Fecha de nacimiento(yyyymmdd):');
        ReadLn(alu.fechaNac);
        Write(arch,alu);
        WriteLn('DNI(0=salir):');
        ReadLn(alu.DNI);
    end;
end;

procedure modificar(var arch:tArchAlumnos);
var
    alu:alumno;
    legajo:String[7];
    pos:Integer;
begin
    Reset(arch);
    pos:=FilePos(arch);
    alu.legajo:='';
    WriteLn('Legajo:');
    ReadLn(legajo);
    while (not eof(arch) and (legajo <> alu.legajo)) do begin
        Read(arch,alu);
        if (legajo = alu.legajo) then
        begin
            Seek(arch,pos);
            WriteLn('Nuevo año:');
            ReadLn(alu.anio);
            Write(arch,alu);
        end;
        pos:=FilePos(arch);
    end;
    if (eof(arch)) then
        WriteLn('No existe alumno con el legajo ',legajo,'.');    
end;


var
    arch:tArchAlumnos;
    alu:alumno;
    opc:Integer;
begin
    Assign(arch,'alumnos.bin');
    repeat
        Opciones;
        ReadLn(opc);
        case opc of
            1:crear(arch);
            2:listar(arch);
            3:alumnos5to(arch);
            4:agregarAlumno(arch);
            5:modificar(arch);
        end;
    until (opc=0);
    Close(arch);
end.