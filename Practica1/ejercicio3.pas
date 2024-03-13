Program ejercicio3;
Var 
    arch:Text;
    dinosaurio:String;
Begin
    Assign(arch,'Tipos de dinosaurios');
    Rewrite(arch);
    Write('Dinosaurio:');
    ReadLn(dinosaurio);
    while(dinosaurio <> 'zzz') do begin
        WriteLn(arch,dinosaurio);
        Write('Dinosaurio:');
        ReadLn(dinosaurio);
    end;
    Close(arch);
end.
