# database1

###
pasar lo datos:
```
scp funciones.sql 
clientes_banco.csv 
pagos_cuotas.csv 
prestamos_banco.csv 
{user}@pampero.itba.edu.ar:/home/{user}
```
Crear las tablas y triggers:
```
```

conctarme a la basedatos:
```
psql -h bd1.it.itba.edu.ar -U {user} PROOF
```

pasar csv a las tablas:
```
\copy clientes_banco(id,dni,telefono,nombre,direccion)
FROM 'clientes_banco.csv'
delimiter ','
csv header;

\copy prestamos_banco(id,fecha,cliente_id,importe)
FROM 'prestamos_banco.csv'
delimiter ','
csv header;

\copy pagos_cuotas(nro,prestamo_id,importe,fecha)
FROM 'pagos_cuotas.csv'
delimiter ','
csv header;

```
