Program ejercicio6;
Type
    Libro=record
        ISBN:LongInt;
        titulo:String[50];
        genero:String[50];
        editorial:String[50];
        anio:Integer;
    end;
    tArchLibros=File of Libro;

procedure Opciones;
begin
    WriteLn('Opciones:');
    WriteLn('0:Salir');
    WriteLn('1:Agregar libro');
    WriteLn('2:Modificar libro');
    WriteLn('3:Imprimir libros');
end;

procedure agregar(var arch:tArchLibros);
var
    l:Libro;
begin
    Seek(arch,FileSize(arch));
    WriteLn('ISBN:');
    ReadLn(l.ISBN);
    WriteLn('Titulo:');
    ReadLn(l.titulo);
    WriteLn('Anio:');
    ReadLn(l.anio);
    WriteLn('Editorial:');
    ReadLn(l.editorial);
    WriteLn('Genero:');
    ReadLn(l.genero);
    Write(arch,l);
end;

procedure modificar(var arch:tArchLibros);
var
    pos:Integer;
    l:Libro;
    ISBN:LongInt;
begin
    l.ISBN:=0;
    Reset(arch);
    pos:=FilePos(arch);
    WriteLn('ISBN del libro a modificar:');
    ReadLn(ISBN);
    while (not Eof(arch) and (ISBN <> L.ISBN)) do begin
        Read(arch,l);
        if(ISBN=l.ISBN) then
        begin
            Seek(arch,pos);
            WriteLn('Titulo:');
            ReadLn(l.titulo);
            WriteLn('Anio:');
            ReadLn(l.anio);
            WriteLn('Editorial:');
            ReadLn(l.editorial);
            WriteLn('Genero:');
            ReadLn(l.genero);
            Write(arch,l);
        end;
        pos:=FilePos(arch);
    end;
    if (Eof(arch)) then
      WriteLn('El libro no existe.');
end;

procedure imprimir(var arch:tArchLibros);
var
    l:Libro;
begin
    WriteLn('----------Libros----------');
    Reset(arch);
    while (not eof(arch)) do begin
        Read(arch,l);
        WriteLn(l.ISBN,' ',l.titulo,' ',l.genero,' ',l.editorial,' ',l.anio);
    end;
    WriteLn('------------------------------');
end;

Var
    arch:tArchLibros;
    archT:Text;
    l1:Libro;
    opc:Integer;

begin
    Assign(archT,'libros.txt');
    Reset(archT);
    Assign(arch,'binarioLibros');
    Rewrite(arch);
    while (not eof(archT)) do begin
        ReadLn(archT,l1.ISBN,l1.titulo);
        ReadLn(archT,l1.anio,l1.editorial);
        ReadLn(archT,l1.genero);
        Write(arch,l1);
    end;
    repeat
        Opciones;
        ReadLn(opc);
        case opc of 
            1:agregar(arch);
            2:modificar(arch);
            3:imprimir(arch);
        end;  
    until (opc=0);
end.