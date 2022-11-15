# TPE Bases de Datos I
## Autores: Felipe Cupitó, Juan Pablo Arias, Nicole Hinojo Toré
### 1. Pasar los archivos a Pampero:
```
scp funciones.sql 
clientes_banco.csv 
pagos_cuotas.csv 
prestamos_banco.csv 
{user}@pampero.itba.edu.ar:/home/{user}
```

### 2. Conectarse a pampero:
```
ssh {user}@pampero.itba.edu.ar
```

### 3. Crear las tablas y triggers
```
psql -h bd1.it.itba.edu.ar -U {user} -f funciones.sql PROOF
```

### 4. Conectarse a la DB del ITBA por consola de PSQL:
```
psql -h bd1.it.itba.edu.ar -U {user} PROOF
```

### 5. Importar los datos de los CSVs a las tablas:
#### (Ejecutar una instrucion a las vez)
```
\copy clientes_banco(id,dni,telefono,nombre,direccion)
FROM 'clientes_banco.csv'
delimiter ','
csv header;
```
```
\copy prestamos_banco(id,fecha,cliente_id,importe)
FROM 'prestamos_banco.csv'
delimiter ','
csv header;
```
```
\copy pagos_cuotas(nro,prestamo_id,importe,fecha)
FROM 'pagos_cuotas.csv'
delimiter ','
csv header;
```

