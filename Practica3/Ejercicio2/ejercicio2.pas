program ejercicio2;
Type
    tVehiculo= Record
        codigoVehiculo:integer;
        patente:String[7];
        motor:String;
        cantidadPuertas:integer;
        precio:real;
        descripcion:String;
    end;
tArchivo = File of tVehiculo;

procedure crear(var arch: tArchivo);
var
    archT:Text;
    vehiculo:tVehiculo;
begin
    Assign(archT,'vehiculos.txt');
    Reset(archT);
    Rewrite(arch);
    vehiculo.codigoVehiculo:=-32767;
    vehiculo.descripcion:='0';
    Write(arch,vehiculo);
    while (not eof(archT)) do begin
        ReadLn(archT,vehiculo.codigoVehiculo);
        ReadLn(archT,vehiculo.patente);
        ReadLn(archT,vehiculo.motor);
        ReadLn(archT,vehiculo.cantidadPuertas);
        ReadLn(archT,vehiculo.precio);
        ReadLn(archT,vehiculo.descripcion);
        Write(arch,vehiculo);
    end;
    Close(archT);

end;

Procedure agregar(var arch: tArchivo; vehiculo: tVehiculo);
var
    veh:tVehiculo;
    nLibre,codError:Integer;
begin
    Reset(arch);
    Read(arch,veh);
    Val(veh.descripcion,nLibre,codError);
    if (codError = 0) then begin
        if (nLibre = 0) then begin
            Seek(arch,FileSize(arch));
        end else begin
            Seek(arch,nLibre);
            Read(arch,veh);
            Seek(arch,0);
            Write(arch,veh);
            Seek(arch,nLibre);
        end;
        Write(arch,vehiculo);
    end else begin
        WriteLn('Hubo un error en la conversion de string a entero');
    end;
end;

Procedure eliminar(var arch: tArchivo; codigoVehiculo: integer);
var
    vehiculo:tVehiculo;
    nLibre:Integer;
    sLibre:tVehiculo; 
begin
    Reset(arch);
    vehiculo.codigoVehiculo:=-1;
    Read(arch,sLibre);
    while ((not eof(arch)) and (vehiculo.codigoVehiculo <> codigoVehiculo)) do begin
        Read(arch,vehiculo);
    end;
    if (vehiculo.codigoVehiculo = codigoVehiculo) then
    begin
        nLibre:=FilePos(arch)-1;
        Seek(arch,nLibre);//Voy a la poscicion del registro a eliminar
        Write(arch,sLibre);//Escribo la cabecera de la lista en el registro a eliminar
        Str(nLibre,sLibre.descripcion);//Guardo en el registro cabecera del archivo la nueva posicion del siguiente libre
        Seek(arch,0);//Voy al inicio del archivo
        Write(arch,sLibre);//Guardo la nueva cabecera
    end else begin
        WriteLn('No esxiste el vehiculo.');
    end;
end;


var 
    arch: tArchivo;
    veh:tVehiculo;
begin
    Assign(arch,'vehiculos.dat');
    crear(arch);
    eliminar(arch,101);
    eliminar(arch,1010);
    eliminar(arch,777);
    eliminar(arch,202);
    veh.codigoVehiculo:=1212;
    veh.patente:='ZZZ121';
    veh.motor:='Diésel';
    veh.cantidadPuertas:=4;
    veh.precio:=10000.0;
    veh.descripcion:='Un auto';
    agregar(arch,veh);
    Reset(arch);
    while (not eof(arch)) do begin
        Read(arch,veh);
        WriteLn(veh.codigoVehiculo,' ',veh.descripcion);
    end;
end.