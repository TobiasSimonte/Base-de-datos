program ejercicio1;
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

var
    empleados:archEmpleados;
    licencias:arrLicencias;
    licDenegadas:Text;
    i:Integer;
    emp:empleado;
begin
    leerInfo(empleados,licencias);
    
    
end.