program ejercicio1;
const
    valoralto=9999;
type
    empleado=record
        codEmpleado:Integer;
        nombre:String[20];
        apellido:String[20];
        fechaNac:String[10];
        direccion:String[40];
        cantHijos:Integer;
        telefono:String;
        vacaciones:Integer;
    end;
    licencia=record
        codEmpleado:Integer;
        fecha:String[10];
        cantDias:Integer;
    end;
    archEmpleados=file of empleado;
    archLicencias=file of licencia;
    arrLicencias=array[1..10] of archLicencias;
    arrLicencia=array[1..10] of licencia;

procedure leerInfo(var empleados:archEmpleados;var licencias:arrLicencias);
var
    archE:Text;
    archL:Text;
    emp:empleado;
    lic:licencia;
    i:Integer;
    str:String;
    c:Char;
begin
    Assign(empleados,'maestroejer1.bin');
    Rewrite(empleados);
    Assign(archE,'masterejer1.txt');
    Reset(archE);
    Assign(archL,'detallesejer1.txt');
    Reset(archL);
    while(not eof(archE)) do begin
        ReadLn(archE,emp.codEmpleado,emp.nombre);
        ReadLn(archE,emp.apellido);
        ReadLn(archE,emp.fechaNac);
        ReadLn(archE,emp.direccion);
        ReadLn(archE,emp.cantHijos,emp.telefono);
        ReadLn(archE,emp.vacaciones);
        Write(empleados,emp);
    end;
    for i:=1 to 10 do begin
        c:=Chr(i+47);
        str:='detalle'+c+'.bin';
        Assign(licencias[i],str);
        Rewrite(licencias[i]);
    end;   
    while(not eof(archL)) do begin
        ReadLn(archL,lic.codEmpleado,lic.cantDias,lic.fecha);
        i:=(lic.codEmpleado mod 10);
        if (i = 0) then
            i:=10;
        Seek(licencias[i],FileSize(licencias[i]));
        Write(licencias[i],lic);
    end;
    Reset(empleados);
    for i:=1 to 10 do
      Reset(licencias[i]);
    Close(archE);
    Close(archL);
end;

procedure leer(var archL:archLicencias;var regd:licencia);
begin
    if (not Eof(archL))
        then
            Read(archL,regd)
        else
            regd.codEmpleado:=valoralto;
end;

procedure minimo(var regd:arrLicencia;var min:licencia;var licencias:arrLicencias);
var
    indexmin:Integer;
    i:Integer;
begin
    min.codEmpleado:=9999;
    for i:=1 to 10 do begin
        if (regd[i].codEmpleado <= min.codEmpleado) then begin
          min:=regd[i];
          indexmin:=i;
        end;
    end;
    leer(licencias[indexmin],regd[indexmin]);
end;

procedure actualizarMaestro(var empleados:archEmpleados;var licencias:arrLicencias);
var
    licDenegadas:Text;
    regd:arrLicencia;
    regm:empleado;
    i:Integer;
    min:licencia;
    aux:Integer;
begin
    Assign(licDenegadas,'LicenciasDenegadas.txt');
    Rewrite(licDenegadas);
    Reset(empleados);
    for i:=1 to 10 do begin
        Reset(licencias[i]);
    end;
    if (not Eof(empleados)) then
        Read(empleados,regm);
    for i:=1 to 10 do begin
        leer(licencias[i],regd[i]);
    end;
    minimo(regd,min,licencias);
    while (min.codEmpleado <> valoralto) do begin
        while (regm.codEmpleado <> min.codEmpleado)do begin
            Read(empleados,regm);
        end;
        aux:=min.codEmpleado;
        while (aux = min.codEmpleado) do begin
            if (regm.vacaciones >= min.cantDias) then begin
                regm.vacaciones:=regm.vacaciones-min.cantDias;
            end else begin
                WriteLn(licDenegadas,regm.codEmpleado,' ',regm.nombre,' ',regm.apellido,' solicita ',min.cantDias,' dias de vacaciones y solo posee ',regm.vacaciones,' dias restantes.');
            end;
            minimo(regd,min,licencias);
        end;
        Seek(empleados,FilePos(empleados)-1);
        Write(empleados,regm);
    end;
    Close(empleados);
    for i:=1 to 10 do begin
        Close(licencias[i]);
    end;
    Close(licDenegadas);
end;
var
    empleados:archEmpleados;
    licencias:arrLicencias;
begin
    leerInfo(empleados,licencias);
    actualizarMaestro(empleados,licencias);
end.