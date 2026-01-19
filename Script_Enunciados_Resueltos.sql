-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
	select "title"
	from "film"
	where "rating" = 'R';

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
	select "first_name"
	from "actor"
	where "actor_id" between 30 and 40;

--4. Obtén las películas cuyo idioma coincide con el idioma original. (En la columna de original_language_id los datos son NULL por lo que no hay coincidencias)
	select "title"
	from "film"
	where "language_id" = "original_language_id";

--5. Ordena las películas por duración de forma ascendente.
	select "title"
	from "film"
	order by "length" asc;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
	select "first_name", "last_name"
	from "actor"
	where "last_name" = 'ALLEN';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
	select "rating", count(rating) as "Clasificación"
	from "film"
	group by "rating";

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
	select "title"
	from "film"
	where "rating" = 'PG-13'
	or "length" > 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
	select STDDEV("replacement_cost") as "Variabilidad_reemplazo_peliculas"
	from "film";

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
	select MAX("length") as "Mayor_Duración", MIN("length") as "Menor_Duración"
	from "film";

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día (hay muchas comrpas con la misma fecha y hora, por lo que el resultado est{a afectado por ese motivo)
	select *
	from "payment"
	order by "payment_date" desc
	limit 1 offset 2;

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
	select "title"
	from "film"
	where "rating" not in ('NC-17' , 'G');

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
	select "rating" , avg("length") as "promedio_duracion"
	from "film"
	group by "rating"
	order by "rating";

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
	select "title"
	from "film"
	where "length" > 180;

--15. ¿Cuánto dinero ha generado en total la empresa? 
	select sum("amount") as "ganancias"
	from "payment";

--16. Muestra los 10 clientes con mayor valor de id.
	select "first_name" , "last_name"
	from "customer"
	order by "customer" desc
	limit 5;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
--información que necesito: (film_id . title) de film (film_id . actor_id) de film_actor (actor_id . first_name . last_name) de actor	
--Dejo detalladas dos versiones debido a que llegué al mismo resultado de dos formas diferentes, luego de ver en clase una forma más simplificada de lo que había desarrollado
	--versión 1:
select a."first_name" , a."last_name"
	from "actor" as "a"
	inner join (
	(select f."film_id" , fa."actor_id" ,f."title"
	from "film" as "f"
	inner join 
		"film_actor" as "fa" on fa."film_id" = f."film_id")) as "ei" on a."actor_id" = ei."actor_id"
	where ei."title" = 'EGG IGBY';
	
	--versión 2 simplificada
	select a."first_name", a."last_name"
	from "actor" as "a"
	inner join "film_actor" as "fa" on fa."actor_id" = a."actor_id"
	inner join "film" as "f" on f."film_id" = fa."film_id"
	where f."title" = 'EGG IGBY';
	
--18. Selecciona todos los nombres de las películas únicos.
	select distinct("title")
	from "film";

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
-- información que necesito: (film_id . title) de film (film_id . category_id) de film_category (category_id . name) category
--Dejo detalladas dos versiones debido a que llegué al mismo resultado de dos formas diferentes, luego de ver en clase una forma más simplificada de lo que había desarrollado
	--versión 1
	select cat."title"
	from "category" as "c"
	inner join (
	(select f."film_id" , fc."category_id", f."title" , f."length"
	from "film" as "f"
	inner join 
		"film_category" as "fc" on fc."film_id" = f."film_id")) as "cat" on c.category_id = cat.category_id
	where c."name" = 'Comedy' and cat."length" > 180;

	--versión 2 simplificada
	select f."title"
	from "film" as "f"
	inner join film_category "fc" on fc."film_id" = f."film_id"
	inner join "category" as "c" on c."category_id" = fc."category_id"
	where c."name" = 'Comedy'
  	and f."length" > 180;


--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
--Dejo detalladas dos versiones debido a que llegué al mismo resultado de dos formas diferentes, luego de ver en clase una forma más simplificada de lo que había desarrollado
	--versión 1
	select avg(cat."length") as "promedio_duración"  , c."name" 
	from "category" as "c"
	inner join (
	(select f."film_id" , fc."category_id", f."title" , f."length" 
	from "film" as "f"
	inner join "film_category" as "fc" on fc."film_id" = f."film_id")) as "cat" on c."category_id" = cat."category_id"
	group by c."name" 
	having  avg(cat."length") > 110;

	--versión 2 simplificada
	select c."name" AS "categoria", avg(f."length") as "promedio_duracion"
	from "category" as "c"
	left join "film_category" as "fc" on fc."category_id" = c."category_id"
	left join "film" as "f" on f."film_id" = fc."film_id"
	group by c."name"
	having avg(f."length") > 110;
	
--21. ¿Cuál es la media de duración del alquiler de las películas?
	select avg("return_date" - "rental_date") as "media_duracion_alquiler"
	from "rental";

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
	select concat("first_name" , ', ' , "last_name") as "nombre_completo"
	from "actor";

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
	select count("rental_id") , "rental_date"
	from "rental"
	group by "rental_date"
	order by count("rental_id") desc;

--24. Encuentra las películas con una duración superior al promedio.
	select "title"
	from "film"
	where "length" > (select avg("length")
    from "film");

--25. Averigua el número de alquileres registrados por mes.
	select date_trunc('month', "rental_date") as "mes", count("rental_id") as "cantidad_alquileres"
	from "rental"
	group by date_trunc('month', "rental_date");

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
	select avg(amount) as "promedio" , stddev("amount") as "desviación_estándar" , variance ("amount") as "varianza"
	from "payment";

--27. ¿Qué películas se alquilan por encima del precio medio?
	select "title", "rental_rate"
	from "film"
	where "rental_rate" > ( select avg("rental_rate")
    from "film")
	order by "rental_rate";

--28. Muestra el id de los actores que hayan participado en más de 40 películas.
	select "actor_id"
	from "film_actor"
	group by "actor_id"
	having count("film_id") > 40;

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
	select f."title" , count(i."inventory_id") as "cantidad_invetario"
	from "film" as "f"
	left join "inventory" as "i" on f."film_id" = i."film_id"
	group by f."title";

--30. Obtener los actores y el número de películas en las que ha actuado.
	select concat(a."first_name", ', ', a."last_name") as "actores", count(fa."film_id") as "cantidad_peliculas"
	from "actor" as "a"
	inner join "film_actor" as "fa" on fa."actor_id" = a."actor_id"
	group by a."actor_id", a."first_name", a."last_name";

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
	select f."title", a."first_name", a."last_name"
	from "film" as "f"
	left join "film_actor" as "fa" on fa."film_id" = f."film_id"
	left join "actor" as "a" on a."actor_id" = fa."actor_id";

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
	select a."first_name" , a."last_name", f."title"
	from "actor" as "a"
	left join "film_actor" as "fa" on fa."actor_id" = a."actor_id"
	left join "film" as "f" on f."film_id" = fa."film_id";

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.
	select f."title", r."rental_id", r."rental_date", r."customer_id"
	from "film" as "f"
	left join "inventory" as "i" on i."film_id" = f."film_id"
	left join "rental" as "r" on r."inventory_id" = i."inventory_id";

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
	select concat(c."first_name", ', ', c."last_name") as "clientes", sum(p."amount") as "gasto_total"
	from "customer" as c
	join "payment" as p on p."customer_id" = c."customer_id"
	group by c."customer_id", c."first_name", c."last_name"
	order by "gasto_total" desc
	limit 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'. 
	select concat("first_name" , ', ' , "last_name") as "nombre_apellido"
	from "actor"
	where "first_name" = 'JOHNNY';

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
	select "actor_id" , "first_name" as "Nombre" , "last_name" as "Apellido" , "last_update"
	from "actor";

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
	select min(actor_id) , max(actor_id)
	from "actor";

--38. Cuenta cuántos actores hay en la tabla “actor”.
	select count("actor_id")
	from "actor";

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
	select "last_name" , "first_name"
	from "actor"
	order by "last_name";

--40. Selecciona las primeras 5 películas de la tabla “film”.
	select "title"
	from "film"
	limit 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
	select "first_name", count("last_name") as "cantidad_nombres"
	from "actor"
	group by "first_name"
	order by "cantidad_nombres" desc;

	--si quiero saber cuál es el más repetido deberia hacer una subconsulta: 
	select "first_name", count("last_name") as "cantidad_nombres"
	from "actor"
	group by "first_name"
	having count("last_name") = ( 
		select max("cantidad")
    	from 
    		(select count(*) as "cantidad"
      		from "actor"
      		group by "first_name") as "cantidad"
		);
	
--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
	select r."rental_id", concat(c."first_name", ', ', c."last_name") as "nombre_cliente", r."rental_date"
	from "rental" as r
	join "customer" as c on c."customer_id" = r."customer_id";

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
	select c."first_name" , c."last_name" , r."rental_id"
	from "customer" as c
	left join "rental" as r on r."customer_id" = c."customer_id";

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
	select *
	from "film"
	cross join "category";

	-- No aporta valor a la consulta ya que no es una relación real entre las categorias y las peliculas, sería más útil realizar un inner join, ya que si me daría como resultado dodne haya coincidencia entre las dos tablas.

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.
	select concat(a."first_name" , ', ' , a."last_name") as "nombres_actores_accion"
	from "actor" as a
	inner join "film_actor" as fa on a."actor_id" = fa."actor_id"
	inner join "film_category" as fc on fa."film_id" = fc."film_id"
	inner join "category" as c on c."category_id" = fc."category_id"
	where c."name" = 'Action';

--46. Encuentra todos los actores que no han participado en películas.
	select concat("first_name", ', ' , "last_name") as "nombre_apellido"
	from "actor" as a
	left join "film_actor" as fa on fa."actor_id" = a."actor_id"
	where fa."film_id" is null;

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
	select concat(a."first_name", ', ', a."last_name") as "nombre_apellido", count(fa."film_id") as "cantidad_peliculas"
	from "actor" as a
	left join "film_actor" as fa on fa."actor_id" = a."actor_id"
	group by a."actor_id", a."first_name", a."last_name";

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
	create view "actor_num_peliculas" as
	select concat(a."first_name", ', ', a."last_name") as "nombre_apellido", count(fa."film_id") as "cantidad_peliculas"
	from "actor" as a
	left join "film_actor" as fa on fa."actor_id" = a."actor_id"
	group by a."actor_id", a."first_name", a."last_name";

--49. Calcula el número total de alquileres realizados por cada cliente.
	select concat(c."first_name" , ', ' , "last_name") as "nombre_completo" , count(r.rental_id) as "total_alquileres"
	from "customer" as c
	left join "rental" as r on c."customer_id" = r."customer_id"
	group by c."customer_id", c."first_name" , c."last_name";

--50. Calcula la duración total de las películas en la categoría 'Action'.
	select sum(f."length") , c."name"
	from "film" as f
	inner join "film_category" as fc on f."film_id" = fc."film_id"
	inner join "category" as c on fc."category_id" = c."category_id"
	where c."name" = 'Action'
	group by c."name";

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
	create temporary table "cliente_rentas_temporal" as
		select concat(c."first_name" , ', ' , "last_name") as "nombres_clientes", count(r."rental_id") as "total_alquileres"
		from "customer" as c
		left join "rental" as r on c."customer_id" = r."customer_id"
		group by c."customer_id";

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
	create temporary table "peliculas_alquiladas" as
		select f."title", count(r."rental_id") as "cantidad_alquileres"
		from "film" as f
		inner join "inventory" as i on i."film_id" = f."film_id"
		inner join "rental" as r on r."inventory_id" = i."inventory_id"
		group by f."film_id", f."title"
		having count(r."rental_id") >= 10;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
	select f."title"
	from "film" as f
	inner join "inventory" as i on i."film_id" = f."film_id"
	inner join "rental" as r on r."inventory_id" = i."inventory_id"
	inner join "customer" as c on c."customer_id" = r."customer_id"
	where c."first_name" = 'TAMMY' and c."last_name" = 'SANDERS'
 	and r."return_date" is null
	order by f."title" asc;


--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
	select distinct concat(a."first_name",', ' , a."last_name") as "nombre_actores_Sci-Fi"
	from "actor" as a
	inner join "film_actor" as fa on fa."actor_id" = a."actor_id"
	inner join "film_category" as fc on fc."film_id" = fa."film_id"
	inner join "category" as c on c."category_id" = fc."category_id"
	where c."name" = 'Sci-Fi'
	order by "nombre_actores_Sci-Fi";

--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
--62. Encuentra el número de películas por categoría estrenadas en 2006.
--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.






