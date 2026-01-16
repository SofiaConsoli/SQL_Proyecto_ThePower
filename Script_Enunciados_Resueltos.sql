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
	inner join 
		"film_category" as "fc" on fc."film_id" = f."film_id")) as "cat" on c.category_id = cat.category_id
	group by c."name" 
	having  avg(cat."length") > 110;

	--versión 2 simplificada
	select c."name" AS categoria, avg(f."length") as "promedio_duracion"
	from "category" as c
	left join film_category fc on fc.category_id = c.category_id
	left join film f on f.film_id = fc.film_id
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


