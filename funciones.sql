DROP TABLE IF EXISTS clientes_banco cascade;
DROP TABLE IF EXISTS prestamos_banco cascade;
DROP TABLE IF EXISTS pagos_cuotas;
DROP TABLE IF EXISTS backup_tabletable;
DROP TRIGGER IF EXISTS backup ON clientes_banco;

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

CREATE TABLE backup_table(
    dni int not null,
    telefono char(30),
    nombre char(50) not null,
    cant_prest int not null, ---Cantidad de préstamos otorgados
    total_prestamo float not null,  --Monto total de préstamos otorgados
    total_pago float not null,  ---Monto total de pagos realizados
    deudor boolean not null, ---Indicador de pagos pendientes: 1 si no pago

    primary key(dni)
);

create or replace function copyDeletedClient() returns trigger
as $$
    declare
        cant_prest backup_table.cant_prest%type;  ---Cantidad de préstamos otorgados
        total_prestamo backup_table.total_prestamo%type; --Monto total de préstamos otorgados
        total_pago backup_table.total_pago%type;   ---Monto total de pagos realizados
        deudor backup_table.deudor%type;  ---Indicador de pagos pendientes: 1 si no pago

    begin

        select count(*) into cant_prest from  prestamos_banco where cliente_id = OLD.id;

        select sum(importe) into total_prestamo from prestamos_banco where cliente_id = OLD.id;

        select coalesce(sum(pagos_cuotas.importe), 0) into total_pago from (pagos_cuotas inner join prestamos_banco ON prestamos_banco.id = prestamo_id) where cliente_id = OLD.id;

        select into deudor CASE WHEN total_prestamo > total_pago THEN true ELSE false END;

        insert into backup_table values (OLD.dni, OLD.nombre, OLD.telefono, cant_prest, round(total_prestamo::numeric, 2), round(total_pago::numeric, 2), deudor);

        return OLD;

    end
$$LANGUAGE plpgsql;

CREATE TRIGGER backup
    BEFORE DELETE ON clientes_banco
    FOR EACH ROW
    EXECUTE PROCEDURE copyDeletedClient();

/* Test trigger */
--DELETE FROM clientes_banco WHERE id = '1';
--DELETE FROM clientes_banco WHERE id = '2';
--DELETE FROM clientes_banco WHERE id = '4';
--DELETE FROM clientes_banco WHERE id = '5';
--DELETE FROM clientes_banco WHERE id = '36';
--DELETE FROM clientes_banco WHERE id = '37';
