program ejercicio5;
const
    valoralto=32767;
type
    vulnerables = record
        partido: string;
        localidad: string;
        barrio: string;
        numNenes: integer;
        numAdultosMayores: integer;
    end;

procedure leer(var archivo:Text;var vul:vulnerables);
begin
    if (not Eof(archivo)) then begin
        ReadLn(archivo,vul.partido);
        ReadLn(archivo,vul.localidad);
        ReadLn(archivo,vul.barrio);
        ReadLn(archivo,vul.numNenes);
        ReadLn(archivo,vul.numAdultosMayores);
    end else begin
        vul.numNenes:= valoralto;
    end;
end;


var
    archivo:Text;
    vul:vulnerables;
    auxPartido:String;
    auxLocalidad:String;
    totNpartido:Integer;
    totNlocalidad:Integer;
    totAMpartido:Integer;
    totAMlocalidad:Integer;
begin
    Assign(archivo,'Vulnerables.txt');
    Reset(archivo);
    leer(archivo,vul);
    while (vul.numNenes <> valoralto) do begin
        auxPartido:=vul.partido;
        totNpartido:=0;
        totAMpartido:=0;
        WriteLn('Partido: ',vul.partido);
        while ((vul.partido = auxPartido) and (vul.numNenes <> valoralto)) do begin
            auxLocalidad:= vul.localidad;
            totNlocalidad:=0;
            totAMlocalidad:=0;
            WriteLn('Localidad: ',vul.localidad);
            while ((vul.localidad = auxLocalidad) and (vul.numNenes <> valoralto)) do begin
                totNpartido:=totNpartido+vul.numNenes;
                totAMpartido:=totAMpartido+vul.numAdultosMayores;
                totNlocalidad:=totNlocalidad+vul.numNenes;
                totAMlocalidad:=totAMlocalidad+vul.numAdultosMayores;
                leer(archivo,vul);
                WriteLn('Cantidad niños:',vul.numNenes,'   Cantidad adultos:',vul.numAdultosMayores);
            end;
            WriteLn('Total niños localidad ',auxLocalidad,':',totNlocalidad,'   Total adultos localidad ',auxLocalidad,':',totAMlocalidad);
        end;
        WriteLn('TOTAL NIÑOS PARTIDO ',auxPartido,':',totNpartido,'   TOTAL ADULTOS PARTIDO ',auxPartido,':',totAMpartido);
    end;
end.
