Program ejercicio2;
Var 
    max,min:Integer;
    arch:Text;
    numero:Integer;
    nombre:String;
Begin
    max:=0;min:=9999;
    Write('Nombre del archivo:');
    ReadLn(nombre);
    Assign(arch,nombre);
    Reset(arch);
    while(not eof(arch)) do begin
      Read(arch,numero);
      WriteLn(numero);
      if (numero>max) then begin
        max:=numero;
      end
      else begin
        if (numero<min) then begin
            min:=numero;
        end;
      end;
    end;
    WriteLn('Cantidad maxima:',max);
    WriteLn('Cantidad minima:',min);
    Close(arch);
end.
