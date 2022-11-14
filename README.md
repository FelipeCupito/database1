# TPE Bases de Datos I

### Autores: Felipe Cupitó, Juan Pablo Arias, Nicole Hinojo Toré

### Copiar archivos en el servidor del ITBA (Pampero):
```
scp funciones.sql 
clientes_banco.csv 
pagos_cuotas.csv 
prestamos_banco.csv 
{user}@pampero.itba.edu.ar:/home/{user}
```
### Crear las tablas:
```
CREATE TABLE clientes_banco
(
    id int NOT NULL,
    dni int not null,
    telefono char(30),
    nombre char(100) not null,
    direccion char(100),

    primary key(id)
);

CREATE TABLE prestamos_banco(
    id INT NOT NULL,
    fecha date not null,
    cliente_id int not null,
    importe float not null,

    primary key(id),
    foreign key (cliente_id) references clientes_banco on delete cascade
);

CREATE TABLE pagos_cuotas(
    nro INT NOT NULL,
    prestamo_id int not null,
    importe int not null,
    fecha date not null,

    primary key(nro, prestamo_id),
    foreign key (prestamo_id) references prestamos_banco on delete cascade
);

CREATE TABLE backup_(
    dni int not null,
    telefono char(30),
    nombre char(50) not null,
    cant_prest int not null, ---Cantidad de préstamos otorgados
    total_prestamo float not null,  --Monto total de préstamos otorgados
    total_pago float not null,  ---Monto total de pagos realizados
    deudor boolean not null, ---Indicador de pagos pendientes: 1 si no pago

    primary key(dni)
);
```

### Crear trigger y función que se ejecuta antes del borrado:
```
create or replace function copyDeletedClient() returns trigger
as $$
    declare
        cant_prest backup_.cant_prest%type;  ---Cantidad de préstamos otorgados
        total_prestamo backup_.total_prestamo%type; --Monto total de préstamos otorgados
        total_pago backup_.total_pago%type;   ---Monto total de pagos realizados
        deudor backup_.deudor%type;  ---Indicador de pagos pendientes: 1 si no pago

    begin

        select count(*) into cant_prest from  prestamos_banco where cliente_id = OLD.id;

        select sum(importe) into total_prestamo from prestamos_banco where cliente_id = OLD.id;

        select coalesce(sum(pagos_cuotas.importe), 0) into total_pago from (pagos_cuotas inner join prestamos_banco ON prestamos_banco.id = prestamo_id) where cliente_id = OLD.id;

        select into deudor CASE WHEN total_prestamo > total_pago THEN true ELSE false END;

        insert into backup_ values (OLD.dni, OLD.nombre, OLD.telefono, cant_prest, round(total_prestamo::numeric, 2), round(total_pago::numeric, 2), deudor);

        return OLD;

    end
$$LANGUAGE plpgsql;

CREATE TRIGGER backup
    BEFORE DELETE ON clientes_banco
    FOR EACH ROW
    EXECUTE PROCEDURE copyDeletedClient();
```

### Conectarse a la DB del ITBA por consola de PSQL:
```
psql -h bd1.it.itba.edu.ar -U {user} PROOF
```

### Copiar data de CSVs a las tablas desde terminal PSQL:
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

### Tests
```
DELETE FROM clientes_banco WHERE id = '1';
DELETE FROM clientes_banco WHERE id = '2';
DELETE FROM clientes_banco WHERE id = '4';
DELETE FROM clientes_banco WHERE id = '5';
DELETE FROM clientes_banco WHERE id = '36';
DELETE FROM clientes_banco WHERE id = '37';
```

