Program ejercicio1;
Var 
    arch:Text;
    material,nombre:String;
Begin
    Write('Nombre del archivo:');
    ReadLn(nombre);
    Assign(arch,nombre);
    Rewrite(arch);
    repeat
      Write('Nombre del material:');
      ReadLn(material);
      WriteLn(arch,material);
    until material='cemento';
    Close(arch);
end.
