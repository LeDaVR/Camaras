
create table persona(
	dni integer PRIMARY KEY,
	nombres varchar(50),
	p_apellido varchar(30),
	m_apellido varchar(30),
	usuario varchar(20),
	contrasenia varchar(20),
	telefono integer,
	email varchar(50)
);

create table administrador(
	dni_admin integer PRIMARY KEY,
	sueldo integer
);

create table carrito(
	id_carrito serial PRIMARY KEY,
	dni_usuario integer
);

create table usuario(
	dni_usuario integer PRIMARY KEY,
	saldo integer
);

create table recarga(
	id_recarga serial PRIMARY KEY,
	monto integer,
	dni_usuario integer
);

create table venta(
	id_venta serial PRIMARY KEY,
	fecha date,
	dni_usuario integer 
);

create table venta_pro(
	id_venta serial,
	codigo_producto serial,
	PRIMARY KEY(id_venta,codigo_producto)
);

create table comentario(
	id_comentario serial PRIMARY KEY,
	comentario varchar(100),
	puntuacion integer,
	codigo_producto serial,
	dni_usuario integer
);

create table carr_pro(
	id_carrito serial,
	codigo_producto serial,
	PRIMARY KEY(id_carrito,codigo_producto)
);

create table producto(
	codigo_producto serial PRIMARY KEY,
	nombre varchar(150),
	categoria varchar(30),
	marca varchar(30),
	precio integer
);

create table tarjeta_memoria(
	codigo_tarj serial PRIMARY KEY
);

create table lente(
	codigo_lente serial PRIMARY KEY
);

create table tripode(
	codigo_tripode serial PRIMARY KEY
);

create table camara(
	codigo_cam serial PRIMARY KEY
);

create table proveedor(
	codigo_proveedor serial PRIMARY KEY,
	nombre varchar(30),
	direccion varchar(30),
	provincia varchar(30),
	telefono integer
);

create table compra(
	id_compra serial PRIMARY KEY,
	fecha date,
	codigo_proveedor serial
);

create table pro_compra(
	codigo_producto serial,
	id_compra serial,
	precio integer,
	cantidad integer,
	PRIMARY KEY(codigo_producto,id_compra)
);

create table caracteristica(
	id_caracteristica serial PRIMARY KEY,
	nombre varchar(20)
);

create table foto(
	id_foto serial PRIMARY KEY,
	imagen varchar(100),
	codigo_producto serial
);

create table almacen(
	id_almacen serial PRIMARY KEY,
	direccion varchar(40),
	capacidad integer
);

create table produc_carac(
	codigo_producto serial,
	id_caracteristica serial,
	valor varchar(30),
	PRIMARY KEY(codigo_producto,id_caracteristica)
);

create table producto_almacen(
	codigo_producto serial,
	id_almacen serial,
	stock integer,
	PRIMARY KEY(codigo_producto,id_almacen)
);

alter table administrador add foreign key (dni_admin) references persona(dni);
alter table usuario add foreign key (dni_usuario) references persona(dni);
alter table recarga add foreign key (dni_usuario) references usuario(dni_usuario);
alter table carrito add foreign key (dni_usuario) references usuario(dni_usuario);
alter table venta add foreign key (dni_usuario) references usuario(dni_usuario);
alter table venta_pro add foreign key (id_venta) references venta(id_venta);
alter table venta_pro add foreign key (codigo_producto) references producto(codigo_producto);
alter table comentario add foreign key (dni_usuario) references usuario(dni_usuario);
alter table comentario add foreign key (codigo_producto) references producto(codigo_producto);
alter table carr_pro add foreign key (id_carrito) references carrito(id_carrito);
alter table carr_pro add foreign key (codigo_producto) references producto(codigo_producto);
alter table tarjeta_memoria add foreign key (codigo_tarj) references producto(codigo_producto);
alter table lente add foreign key (codigo_lente) references producto(codigo_producto);
alter table tripode add foreign key (codigo_tripode) references producto(codigo_producto);
alter table camara add foreign key (codigo_cam) references producto(codigo_producto);
alter table compra add foreign key (codigo_proveedor) references proveedor(codigo_proveedor);
alter table pro_compra add foreign key (id_compra) references compra(id_compra);
alter table pro_compra add foreign key (codigo_producto) references producto(codigo_producto);
alter table foto add foreign key (codigo_producto) references producto(codigo_producto);
alter table produc_carac add foreign key (codigo_producto) references producto(codigo_producto);
alter table produc_carac add foreign key (id_caracteristica) references caracteristica(id_caracteristica);
alter table producto_almacen add foreign key (codigo_producto) references producto(codigo_producto);
alter table producto_almacen add foreign key (id_almacen) references almacen(id_almacen);