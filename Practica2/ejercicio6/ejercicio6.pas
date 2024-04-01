program ejercicio6;
const
    valoralto=32767;
type
    servicio = record
        codigo:Integer;
        fecha:String;
        monto:Double;
    end;
    archMozos = file of servicio;

procedure GenerarMozos;
var
    archT:Text;
    archB:archMozos;
    s:servicio;
begin
    Assign(archT,'mozos.txt');
    Reset(archT);
    Assign(archB,'mozos.bin');
    Rewrite(archB);
    while (not Eof(archT)) do begin
        ReadLn(archT,s.codigo);
        ReadLn(archT,s.fecha);
        ReadLn(archT,s.monto);
        Write(archB,s);
    end;
    Close(archT);
    Close(archB);
end;

procedure leer(var mozos:archMozos; var serv:servicio);
begin
    if (not Eof(mozos)) then begin
      Read(mozos,serv);
    end else begin
        serv.codigo:=valoralto;
    end;
end;

procedure CompactarMozos(var mozos:archMozos);
var
    mozosComp:archMozos;
    serv,aux:servicio;
begin
    Assign(mozosComp,'mozosCompactados.bin');
    Rewrite(mozosComp);
    Reset(mozos);
    leer(mozos,serv);
    while (serv.codigo <> valoralto) do begin
        aux:=serv;
        aux.monto:=0;
        while (aux.codigo = serv.codigo) do begin
            aux.monto:=aux.monto+serv.monto;
            leer(mozos,serv);
        end;
        Write(mozosComp,aux);
    end;
    Close(mozosComp);
end;

var
    mozos:archMozos;
    serv:servicio;
begin
    GenerarMozos;
    Assign(mozos,'mozos.bin');
    CompactarMozos(mozos);
    //Assign(mozos,'mozosCompactados.bin');
    //Reset(mozos);
    //while (not Eof(mozos)) do begin
    //    Read(mozos,serv);
    //    WriteLn(serv.codigo,' ',serv.fecha,' ',serv.monto);
    //end;
    Close(mozos);
end.

