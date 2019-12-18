-- funcion para insertar un usuario
CREATE OR REPLACE FUNCTION insertar_usuario(dnie integer,nombres varchar(50),papellido varchar(30),spaellido varchar(30),euser varchar(20),
											contraseniae varchar(20),telef integer,email varchar(50))
RETURNS TEXT AS $$
	DECLARE 
		respuesta TEXT;
	BEGIN
		insert into persona values(dnie,nombres,papellido,spaellido,euser,contraseniae,telef,email);
		insert into usuario values(dnie,0);
		insert into carrito(dni_usuario) values(dnie);
		RETURN 'Se registro Correctamente';
		EXCEPTION
			WHEN unique_violation THEN
				RETURN 'DNI ya registrado';
			WHEN OTHERS THEN
				RETURN 'A ocurrido un error interno';
	END;
$$
LANGUAGE plpgsql;

--actualizar nuevo usuario
CREATE OR REPLACE FUNCTION actualizar_usuario(dnie integer,enombres varchar(50),papellido varchar(30),spaellido varchar(30),euser varchar(20),
											contraseniae varchar(20),telef integer,emaile varchar(50))
RETURNS TEXT AS $$
	DECLARE 
		respuesta TEXT;
	BEGIN
		UPDATE persona SET nombres=enombres,p_apellido=papellido,
							m_apellido=sapellido,usuario=euser,
							constrasenia=contraseniae,telefono=telef,
							email=emaile where dni = dnie;
		RETURN 'Datos Actualizados';
		EXCEPTION
			WHEN unique_violation THEN
				RETURN 'DNI ya registrado';
			WHEN OTHERS THEN
				RETURN 'A ocurrido un error interno';
	END;
$$
LANGUAGE plpgsql;

--funcion para hacer una recarga a un usuario
CREATE OR REPLACE FUNCTION recargar_usuario(emonto integer,edni_user integer)
RETURNS TEXT AS $$
	DECLARE 
		respuesta TEXT;
	BEGIN
		insert into recarga(monto,dni_usuario) values(emonto,edni_user);
		RETURN 'Recarga realizada con exito';
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION act_saldo_cliente() RETURNS TRIGGER
AS 
$$
BEGIN
	UPDATE usuario SET saldo = saldo + new.monto WHERE dni_usuario = new.dni_usuario;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_recarga_usuario AFTER INSERT ON recarga
FOR EACH ROW
EXECUTE PROCEDURE act_saldo_cliente();

-- funcion para insertar una compra
CREATE OR REPLACE FUNCTION insertar_compra(date fechae,codigo_provee integer)
RETURNS TEXT AS $$
	DECLARE 
		respuesta TEXT;
	BEGIN
		insert into compra values(fechae,codigo_provee);
		RETURN 'Se registro una compra';
	EXCEPTION
		WHEN unique_violation THEN
			RETURN 'El proveedor no existe';
		WHEN OTHERS THEN
			RETURN 'A ocurrido un error interno';
	END;
$$
LANGUAGE plpgsql;


-- funcion para insertar la compra se un producto( requiere el id de la compra)
CREATE OR REPLACE FUNCTION insertar_producto(compraid integer,enombre varchar(150),categoriae varchar(30),emarca varchar(30),ecosto integer,ecantidad integer)
RETURNS TEXT AS $$
	DECLARE 
		respuesta TEXT;
	BEGIN
		insert into producto(nombre,categoria,marca,precio) values(enombre,categoriae,emarca,ecosto+ecosto*25/100);
		insert into pro_compra values(currval(pg_get_serial_sequence('producto', 'codigo_producto')),compraid,ecosto,ecantidad);
		RETURN 'Se registro una compra';
		EXCEPTION
			WHEN unique_violation THEN
				RETURN 'Error';
			WHEN OTHERS THEN
				RETURN 'A ocurrido un error interno';
	END;
$$
LANGUAGE plpgsql;

--actualizar un producto

CREATE OR REPLACE FUNCTION act_producto(codigo integer,enombre varchar(150),categoriae varchar(30),emarca varchar(30),eprecio integer)
RETURNS TEXT AS $$
	DECLARE 
		respuesta TEXT;
	BEGIN
		UPDATE producto SET nombre=enombre,categoria=categoriae,marca=emarca,precio=eprecio
		WHERE codigo_producto=codigo;
		RETURN 'Se registro una compra';
		EXCEPTION
			WHEN unique_violation THEN
				RETURN 'Error';
			WHEN OTHERS THEN
				RETURN 'A ocurrido un error interno';
	END;
$$
LANGUAGE plpgsql;

--vender producto
CREATE OR REPLACE FUNCTION insertar_venta(dni integer)
RETURNS TEXT AS $$
	DECLARE 
		respuesta TEXT;
	BEGIN
		INSERT INTO venta(fecha,dni_usuario) values (current_date,dni);
		RETURN 'Se registro una venta';
		EXCEPTION
			WHEN unique_violation THEN
				RETURN 'Error';
			WHEN OTHERS THEN
				RETURN 'A ocurrido un error interno';
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION vender_producto(idventa integer,codigop integer,eprecio integer,dni integer,esaldo integer)
RETURNS TEXT AS $$
	DECLARE 
		respuesta TEXT;
	BEGIN
		IF eprecio <= esaldo  AND 1<=(SELECT SUM(stock) FROM producto_almacen  WHERE codigo_producto=codigop) codi THEN
			INSERT INTO venta_pro values (idventa,codigop);
			UPDATE usuario SET saldo = saldo-eprecio WHERE dni_usuario=dni;
			UPDATE producto_almacen SET stock = stock-1 WHERE codigo_producto=codigop AND stock =(SELECT MAX(stock) FROM producto_almacen WHERE codigo_producto=codigop);
		END IF;
		RETURN 'Producto vendido';
		EXCEPTION
			WHEN unique_violation THEN
				RETURN 'Error';
			WHEN OTHERS THEN
				RETURN 'A ocurrido un error interno';
	END;
$$
LANGUAGE plpgsql;

-- mostrar productos con tres filtros

CREATE OR REPLACE FUNCTION mostrar_productos(marcae varchar(50),categoriae varchar(50),precioe integer)
	RETURNS TABLE ("NOMBRE" varchar(150), "MARCA" varchar(30), "CATEGORIA" varchar(30), "PRECIO" integer)
AS $$
	BEGIN
		SELECT e.nombre,e.marca,e.categoria,e.precio FROM producto 
		WHERE marca=marcae and categoria=categoriae and precio=precioe;
	END;
$$
LANGUAGE plpgsql;


-- usuarios con dos filtros
CREATE OR REPLACE FUNCTION filtrar_usuarios(enombres varchar(50), esaldo integer)
	RETURNS TABLE ("NOMBRE" varchar(50), "SALDO" integer)
AS $$
	BEGIN
		RETURN QUERY SELECT e.nombres,d.saldo FROM persona e
		inner join usuario d  on d.dni_usuario = e.dni and d.saldo<=esaldo
		and e.nombres like enombres;
	END;
$$
LANGUAGE plpgsql;

/*--select insertar_usuario(721613851,'Nuevo Nombre','Primer apellido','S apllido','Usuario','Contraseña',234516,'nuevo@gmail.com');
--select recargar_usuario(2000,721613851);
--select insertar_venta(721613851);
--select vender_producto(50,16450448,600,721613851,2000);
--select filtrar_usuarios('N%',1500);
select * from persona where nombres like ('N%');
*/