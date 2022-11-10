DROP TABLE IF EXISTS clientes_banco cascade ;
DROP TABLE IF EXISTS prestamos_banco cascade ;
DROP TABLE IF EXISTS pagos_cuotas;
DROP TABLE IF EXISTS backup_;

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
    telefono int not null,
    nombre char(50) not null,
    nro_prestamos char(100) not null,
    total_prestamo float not null,
    total_pago float not null,
    deudor int not null, ---0 false, 1 true

    primary key(dni)
);




*/





