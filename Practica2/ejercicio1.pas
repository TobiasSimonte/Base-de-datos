program ejercicio1;
uses SysUtils;
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
begin
    Assign(empleados,'maestroejer1.bin');
    Rewrite(empleados);
    Assign(archE,'maestroejre1.txt');
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
    while(not eof(archL)) do begin
        ReadLn(archL,lic.codEmpleado);
        ReadLn(archL,lic.fecha);
        ReadLn(archL,lic.cantDias);
        i:=(lic.codEmpleado mod 10);
        if (i = 0) then
          i:=10;
        str:=IntToStr(i);
        str:='detalle'+str+'.bin';
        Assign(licencias[i],str);
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
begin
    leerInfo(empleados,licencias);
end.