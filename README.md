# database1

###
pasar lo datos:
scp funciones.sql clientes_banco.csv pagos_cuotas.csv prestamos_banco.csv {user}@pampero.itba.edu.ar:/home/{user}

crear las tablas y triggers:

conctarme a la basedatos:
psql -h bd1.it.itba.edu.ar -U fcupito PROOF

pasar csv a las tablas:
\copy clientes_banco(id,dni,telefono,nombre,direccion) from clientes_banco.csv delimiter',' csv header

###
