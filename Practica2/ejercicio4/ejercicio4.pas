program ejercicio4;
const
    valorAlto = 9999;
    cantCines = 20;
type
    Pelicula = record
        codigo: integer;
        nombre: string[50];
        genero: string[50];
        director: string[50];
        duracion: integer;
        fecha: String[50];
        asistentes: integer;
    end;

    archivoPeliculas = file of Pelicula;
    arrArchivosPeliculas = array[1..cantCines] of archivoPeliculas;
    arrPeliculas = array[1..cantCines] of Pelicula;


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

procedure generarDetalles(var detalles:arrArchivosPeliculas);
var
    detTexto:Text;
    pel:Pelicula;
    i:Integer;
    str:String;
begin
    Assign(detTexto,'Detalles.txt');
    Reset(detTexto);
    for i:=1 to 20 do begin
        IntegertoString(str,i);
        str:='Detalle'+str+'.bin';
        Assign(detalles[i],str);
        Rewrite(detalles[i]);
    end;
    i:=1;
    while (not Eof(detTexto)) do begin
        ReadLn(detTexto,pel.codigo);
        ReadLn(detTexto,pel.nombre);
        ReadLn(detTexto,pel.genero);
        ReadLn(detTexto,pel.director);
        ReadLn(detTexto,pel.duracion);
        ReadLn(detTexto,pel.fecha);
        ReadLn(detTexto,pel.asistentes);
        Write(detalles[i],pel);
        if (i = 20) then
          i:=0;
        i:=i+1;
    end;
    Close(detTexto);
end;

procedure leer(var archivoPelicula:archivoPeliculas; var pel:Pelicula);
begin
    if (not Eof(archivoPelicula)) then begin
        Read(archivoPelicula,pel);
    end else begin
        pel.codigo:=valoralto;
    end;
end;

procedure minimo(var detalles:arrArchivosPeliculas; var min:Pelicula; var peliculas:arrPeliculas);
var
    i,pos:Integer;
begin
    min:=peliculas[1];
    pos:=1;
    for i:=2 to cantCines do begin
        if (peliculas[i].codigo < min.codigo) then begin
            min:=peliculas[i];
            pos:=i;
        end;
    end;
    leer(detalles[pos],peliculas[pos]);
end;

procedure generarMaestro(rutaMaestro: String; var detalles: arrArchivosPeliculas);
var
    maestro:archivoPeliculas;
    i:Integer;
    peliculas: arrPeliculas;
    min,cargaMaestro:Pelicula;
begin
    Assign(maestro,rutaMaestro);
    Rewrite(maestro);
    for i:=1 to cantCines do begin
        Reset(detalles[i]);
        leer(detalles[i],peliculas[i]);
    end;
    minimo(detalles,min,peliculas);
    while (min.codigo <> valorAlto) do begin
        cargaMaestro:=min;
        cargaMaestro.asistentes:=0;
        while (cargaMaestro.codigo = min.codigo) do begin
            cargaMaestro.asistentes:=cargaMaestro.asistentes+min.asistentes;
            minimo(detalles,min,peliculas);
        end;
        Write(maestro,cargaMaestro);
    end;
    Close(maestro);
end;


var
    rutaMaestro: String;
    detalles: arrArchivosPeliculas;
    
    pel:Pelicula;
    maestro:archivoPeliculas;
    i:Integer;
begin
    generarDetalles(detalles);
    rutaMaestro:='peliculas.dat';
    generarMaestro(rutaMaestro, detalles);
    for i:=1 to cantCines do begin
        Close(detalles[i]);
    end;

    //Test funcionamiento
    //Assign(maestro,rutaMaestro);
    //Reset(maestro);
    //while (not Eof(maestro)) do begin
    //    Read(maestro,pel);
    //    WriteLn(pel.codigo,' ',pel.nombre,' ',pel.genero,' ',pel.director,' ',pel.duracion,' ',pel.fecha,' ',pel.asistentes,'.');
    //end;
    //Close(maestro);

end.