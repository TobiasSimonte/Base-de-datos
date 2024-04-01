program ejercicio8;
const
    cantArq=15;
    valoralto=32767;
type
    Arquitecto = record
        cod_zona:Integer;
        nombre_zona:String;
        descripcion:String;
        fecha:String;
        metros:Integer;
    end;

    Zona = record
        cod_zona:Integer;
        nombre_zona:String;
        metros:Integer;
    end;

    archArquitecto = file of Arquitecto;
    archZona = file of Zona;
    arrArquitectos = array[1..cantArq] of archArquitecto;
    arrRArquitectos = array[1..cantArq] of Arquitecto;


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

procedure generarArquitectos(var detalles_arquitectos:arrArquitectos);
var
    archT:Text;
    i:Integer;
    arq:Arquitecto;
    str:String;
begin
    Assign(archT,'arquitectos.txt');
    Reset(archT);
    for i:=1 to cantArq do begin
        IntegertoString(str,i);
        str:='Detalle'+str+'.dat';
        Assign(detalles_arquitectos[i],str);
        Rewrite(detalles_arquitectos[i]);
    end;
    i:=1;
    while (not Eof(archT)) do begin
        ReadLn(archT,arq.cod_zona);
        ReadLn(archT,arq.nombre_zona);
        ReadLn(archT,arq.descripcion);
        ReadLn(archT,arq.fecha);
        ReadLn(archT,arq.metros);
        Write(detalles_arquitectos[i],arq);
        i:=i+1;
        if (i > cantArq) then
            i:=1;
    end;
    Close(archT);
end;

procedure leer(var archivoA:archArquitecto; var regA:Arquitecto);
begin
    if (not eof(archivoA))then begin
        Read(archivoA,regA)
    end else begin
        regA.cod_zona:=valoralto;
    end;
end;

procedure minimo(var detalles_arquitectos:arrArquitectos;var min:Arquitecto;var arquitectos:arrRArquitectos);
var
    i,pos:Integer;
begin
    min:=arquitectos[1];
    pos:=1;
    for i:=2 to cantArq do begin
        if (arquitectos[i].cod_zona < min.cod_zona) then begin
            min:=arquitectos[i];
            pos:=i;
        end;
    end;
    leer(detalles_arquitectos[pos],arquitectos[pos]);
end;

procedure generarMaestro(var maestro:archZona; var detalles_arquitectos:arrArquitectos);
var
    arquitectos:arrRArquitectos;
    i:integer;
    min,aux:Arquitecto;
    zon:Zona;
    archT:Text;
begin
    Assign(archT,'MetrosPorZona.txt');
    Rewrite(archT);
    Reset(maestro);
    for i:=1 to cantArq do begin
        Reset(detalles_arquitectos[i]);
        leer(detalles_arquitectos[i],arquitectos[i]);
    end;
    minimo(detalles_arquitectos,min,arquitectos);
    while (min.cod_zona <> valoralto) do begin
        aux:=min;
        zon.cod_zona:=min.cod_zona;
        zon.nombre_zona:=min.nombre_zona;
        zon.metros:=0;
        while (min.cod_zona = aux.cod_zona) do begin
            zon.metros:=zon.metros+min.metros;
            minimo(detalles_arquitectos,min,arquitectos);
        end;
        WriteLn(archT,'En la zona ',zon.nombre_zona,' se construyeron ',zon.metros,'m^2.');
        Write(maestro,zon);
    end;
    Close(archT);
end;



var
    detalles_arquitectos:arrArquitectos;
    maestro:archZona;
    i:Integer;
begin
    generarArquitectos(detalles_arquitectos);
    Assign(maestro,'maestro.dat');
    Rewrite(maestro);
    generarMaestro(maestro,detalles_arquitectos);
    Close(maestro);
    for i:=1 to cantArq do begin
        Close(detalles_arquitectos[i]);
    end;
end.