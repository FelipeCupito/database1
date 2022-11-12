DROP TABLE IF EXISTS clientes_banco cascade ;
DROP TABLE IF EXISTS prestamos_banco cascade ;
DROP TABLE IF EXISTS pagos_cuotas;
DROP TABLE IF EXISTS backup_;
DROP FUNCTION copyDeletedClient();

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
    foreign key (cliente_id) references clientes_banco
);

CREATE TABLE pagos_cuotas(
    nro INT NOT NULL,
    prestamo_id int not null,
    importe int not null,
    fecha date not null,

    primary key(nro, prestamo_id),
    foreign key (prestamo_id) references prestamos_banco
);

CREATE TABLE backup_(
    dni int not null,
    telefono char(30),
    nombre char(50) not null,
    cant_prest int not null, ---Cantidad de préstamos otorgados
    total_prestamo float not null,  --Monto total de préstamos otorgados
    total_pago float not null,  ---Monto total de pagos realizados
    deudor int not null, ---Indicador de pagos pendientes: 1 si no pago

    primary key(dni)
);

/*
TODO:
    Query de borrado de cliente de todas las tablas
    Query de data a copiar en la tabla backup
 */

create or replace function copyDeletedClient() returns trigger
as $$
    declare
        cant_prest backup_.cant_prest%type;  ---Cantidad de préstamos otorgados
        total_prestamo backup_.total_prestamo%type; --Monto total de préstamos otorgados
        total_pago backup_.total_pago%type;   ---Monto total de pagos realizados
        deudor backup_.deudor%type;  ---Indicador de pagos pendientes: 1 si no pago

    begin

        select count(*) into cant_prest from  prestamos_banco where cliente_id = dni;

        select sum(importe) into total_prestamo from prestamos_banco where cliente_id = dni;

        insert into backup_ values (OLD.dni, OLD.nombre, OLD.telefono, cant_prest, total_prestamo, null, null);

        select sum(pagos_cuotas.importe) into total_pago from (pagos_cuotas inner join prestamos_banco ON prestamos_banco.id = prestamo_id) where cliente_id = OLD.id;

        /*select into deudor if (total_prestamo > total_pago, "true", "false");*/

        if (total_prestamo > total_pago) then update backup_ set deudor = "true" else update backup_ set deudor = "false";

        return OLD;

    end;
$$LANGUAGE plpgsql;

/*
create trigger backup
    after delete on clientes_banco
    for each row
    execute procedure delete_cliente();
*/

CREATE TRIGGER backup
    BEFORE DELETE ON clientes_banco
    FOR EACH ROW
    EXECUTE PROCEDURE copyDeletedClient();

/* Test trigger */
DELETE FROM clientes_banco WHERE id = '2';
