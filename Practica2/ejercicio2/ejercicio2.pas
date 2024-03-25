program ejercicio2;
const
    valoralto=9999;
type
    CD = record
        codAutor:Integer;
        nombreAutor:String[30];
        nombreDisco:String[30];
        genero:String[20];
        cantVentas:Integer;
    end;
    archivoCd=file of CD;

procedure GenerarBinario;
var
    archT:Text;
    archCD:archivoCd;
    cds:CD;
begin
    Assign(archT,'DiscosVendidos.txt');
    Reset(archT);
    Assign(archCD,'DiscosVendidos.bin');
    Rewrite(archCD);
    while (not eof(archT)) do begin
        ReadLn(archT,cds.codAutor,cds.nombreAutor);
        ReadLn(archT,cds.genero);
        ReadLn(archT,cds.cantVentas,cds.nombreDisco);
        Write(archCD,cds);
    end;
    Close(archT);
    Close(archCD);
end;

procedure leer(var archCD:archivoCd;var cds:CD);
begin
    if (not eof(archCD)) then begin
      Read(archCD,cds);
    end else begin
        cds.codAutor:=valoralto;
    end;
end;

var
    archCD:archivoCd;
    cds:CD;
    auxAutor:Integer;
    totalAutor:Integer;
    auxGenero:String[20];
    totalGenero:Integer;
    totalDiscografica:Integer;
    archTexto:Text;
begin
    GenerarBinario;
    Assign(archCD,'DiscosVendidos.bin');
    Reset(archCD);
    Assign(archTexto,'ArchivoListado.txt');
    Rewrite(archTexto);
    leer(archCD,cds);
    totalDiscografica:=0;
    while (cds.codAutor <> valoralto) do begin
        auxAutor:=cds.codAutor;
        totalAutor:=0;
        WriteLn('Autor:',cds.nombreAutor); //Autor:____
        while ((auxAutor=cds.codAutor) and (cds.codAutor <> valoralto)) do begin
            auxGenero:=cds.genero;
            totalGenero:=0;
            WriteLn('Genero:',cds.genero); //Genero:____
            while ((auxGenero=cds.genero) and (cds.codAutor <> valoralto)) do begin
                totalDiscografica:=totalDiscografica+1;
                totalAutor:=totalAutor+1;
                totalGenero:=totalGenero+1;
                WriteLn('Nombre Disco:',cds.nombreDisco,' cantidad vendida:',cds.cantVentas); //Nombre Disco: ---------- cantidad vendida: ------------
                WriteLn(archTexto,cds.nombreDisco,' ',cds.nombreAutor,' ',cds.cantVentas);
                leer(archCD,cds);
            end;
            WriteLn('Total genero:',totalGenero); //Total Género:
        end;
        WriteLn('Total autor:',totalAutor); //Total Autor:
    end;
    WriteLn('Total discografica:',totalDiscografica); //Total Discografica:
    Close(archCD);
    Close(archTexto);
end.