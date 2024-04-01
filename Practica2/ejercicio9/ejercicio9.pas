program ejercicio9;
const
    cantCarreras=5;
    valoralto=2147483647;
type
    InfoCarrera = record
        dni:LongInt;
        apellido:String[30];
        nombre:String[30];
        kilometros:Integer;
        gano:Integer;
    end;

    Corredor = record
        dni:LongInt;
        apellido:String[30];
        nombre:String[30];
        kilometros:Integer;
        carrerasGanadas:Integer;
    end;

    archCorredores = file of Corredor;
    archCarrera = file of InfoCarrera;
    arrCarreras = array[1..cantCarreras] of archCarrera;
    arrRCarreras = array[1..cantCarreras] of InfoCarrera;

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

procedure GenerarDetalles(var detalles:arrCarreras);
var
    archT:Text;
    i:Integer;
    info:InfoCarrera;
    str:String;
begin
    Assign(archT,'Detalles.txt');
    Reset(archT);
    for i:=1 to cantCarreras do begin
        IntegertoString(str,i);
        str:='Detalle'+str+'.dat';
        Assign(detalles[i],str);
        Rewrite(detalles[i]);
    end;
    i:=1;
    while (not eof(archT)) do begin
        ReadLn(archT,info.dni);
        ReadLn(archT,info.apellido);
        ReadLn(archT,info.nombre);
        ReadLn(archT,info.kilometros);
        ReadLn(archT,info.gano);
        Write(detalles[i],info);
        i:=i+1;
        if (i > cantCarreras) then
          i:=1;
    end;
    Close(archT);
end;

procedure leer(var archC:archCarrera; var regC:InfoCarrera);
begin
    if (not Eof(archC)) then begin
        Read(archC,regC);
    end else begin
        regC.dni:=valoralto;
    end;
      
end;

procedure minimo(var detalles:arrCarreras; var min:InfoCarrera; var arrC:arrRCarreras);
var
    i,pos:Integer;
begin
    pos:=1;
    min:=arrC[1];
    for i:=2 to cantCarreras do begin
        if (arrC[i].dni <= min.dni) then begin
            pos:=i;
            min:=arrC[i];
        end;
    end;
    leer(detalles[pos],arrC[pos]);
end;

procedure generarMaestro(var maestro:archCorredores; var detalles:arrCarreras);
var
    arrC:arrRCarreras;
    i:Integer;
    min:InfoCarrera;
    aux:Corredor;
begin
    Rewrite(maestro);
    for i:=1 to cantCarreras do begin
        Reset(detalles[i]);
        leer(detalles[i],arrC[i]);
    end;
    minimo(detalles,min,arrC);
    while (min.dni <> valoralto) do begin
        aux.dni:=min.dni;
        aux.apellido:=min.apellido;
        aux.nombre:=min.nombre;
        aux.kilometros:=0;
        aux.carrerasGanadas:=0;
        while (aux.dni = min.dni) do begin
            if (min.gano = 1) then
              aux.carrerasGanadas:=aux.carrerasGanadas+1;
            aux.kilometros:=aux.kilometros+min.kilometros;
            minimo(detalles,min,arrC);
        end;
        Write(maestro,aux);     
    end;
end;

var
    maestro:archCorredores;
    detalles:arrCarreras;
    cor:Corredor;
    i:Integer;
begin
    GenerarDetalles(detalles);
    Assign(maestro,'maestro.dat');
    generarMaestro(maestro,detalles);
    Reset(maestro);
    while (not Eof(maestro)) do begin
        Read(maestro,cor);
        WriteLn(cor.dni,' ',cor.apellido,' ',cor.nombre,' ',cor.kilometros,' ',cor.carrerasGanadas,'.');
    end;
    Close(maestro);
    for i:=1 to cantCarreras do begin
        Close(detalles[i]);
    end;
end.