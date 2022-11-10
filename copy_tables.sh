\copy clientes_banco(id,dni,telefono,nombre,direccion)
FROM '~/clientes_banco.csv'
delimiter ','
csv header;

\copy prestamos_banco(id,fecha,cliente_id,importe)
FROM '~/prestamos_banco.csv'
delimiter ','
csv header;

\copy pagos_cuotas(nro,prestamo_id,importe,fecha)
FROM '~/pagos_cuotas.csv'
delimiter ','
csv header;