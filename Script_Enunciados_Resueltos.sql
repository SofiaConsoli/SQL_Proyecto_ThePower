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
--8. 