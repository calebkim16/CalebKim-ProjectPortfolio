--------Q1) 
CREATE VIEW Q1(state, nbreweries) AS
    SELECT l.region AS state, COUNT(l.region) AS nbreweries
	FROM Locations l
	JOIN Breweries b ON (b.located_in = l.id)
	WHERE l.country = 'Australia'
	GROUP BY l.region; 

--------Q2)
CREATE VIEW Q2(style, min_abv, max_abv) AS
    SELECT name AS style, min_abv, max_abv
    FROM styles
    WHERE (max_abv - min_abv) >= ALL(SELECT max_abv - min_abv FROM styles)
    ORDER BY (max_abv - min_abv) DESC;

--------Q3)
CREATE VIEW Q3(style, lo_abv, hi_abv, min_abv, max_abv) AS
    SELECT s.name AS style, (SELECT MIN(b1.ABV)  FROM Beers b1 JOIN Styles s1 ON (b1.style = s1.id) WHERE s1.name = s.name) AS lo_abv, MAX(b.ABV) AS hi_abv, s.min_abv AS min_abv, s.max_abv AS max_abv
	FROM Styles s
	JOIN Beers b ON (b.style = s.id)
	WHERE s.min_abv <> s.max_abv AND (b.ABV > s.max_abv OR b.ABV < s.min_abv)
	GROUP BY s.name, s.min_abv, s.max_abv;

--------Q4)
CREATE OR REPLACE VIEW Q4(brewery, rating) AS
    SELECT br.name AS brewery, CAST(AVG(b.rating) AS numeric (3,1)) AS rating
	FROM Breweries br
	JOIN Brewed_by brb ON (br.id = brb.brewery)
	JOIN Beers b ON (brb.beer = b.id)
	WHERE b.rating IS NOT NULL
	GROUP BY br.name
    HAVING COUNT(brb.beer) >= 5 AND CAST(AVG(b.rating) AS numeric (3,1))  = (
	    SELECT MAX(avg_rating) FROM(
            SELECT br2.name, CAST(AVG(b2.rating) AS numeric(3,1)) AS avg_rating
            FROM Breweries br2	
            JOIN Brewed_by brb2 ON (br2.id = brb2.brewery)
	        JOIN Beers b2 ON (brb2.beer = b2.id)
            WHERE b2.rating IS NOT NULL
	        GROUP BY br2.name
            HAVING COUNT(brb2.beer) >= 5
        ) AS max_rating );

--------Q5)
CREATE FUNCTION Q5(pattern text)
	RETURNS table(beer text, container text, std_drinks numeric(3,1)) AS
	$$
	BEGIN
		RETURN QUERY
        SELECT name AS beer, volume || 'ml ' || sold_in AS container, ROUND((volume * ABV * 0.0008)::numeric, 1) AS std_drinks
		FROM Beers
		WHERE name ILIKE '%' || pattern || '%';
	END;
	$$ LANGUAGE plpgsql;

--------Q6)
CREATE OR REPLACE FUNCTION Q6(pattern text)
    RETURNS TABLE (country text, first integer, nbeers bigint, rating numeric(3,1)) AS
    $$
    BEGIN
    RETURN QUERY
 	   	SELECT l.country AS country, MIN(b.brewed) AS first, COUNT(*) AS nbeers, CAST(AVG(b.rating) AS numeric(3,1)) AS rating
  	  	FROM locations l
  	 	JOIN Breweries br ON (br.located_in = l.id)
 	   	JOIN Brewed_by brb ON (brb.brewery = br.id)
    	JOIN Beers b ON (brb.beer = b.id)
    	WHERE l.country ILIKE '%' || pattern || '%'
    	GROUP BY L.country;
    END;
    $$ LANGUAGE plpgsql;

--------Q7)
CREATE FUNCTION Q7(_beerID integer)
	RETURNS VARCHAR(250) AS
	$$
	DECLARE beer VARCHAR(250);
	DECLARE ingredients_list VARCHAR(250) := ' ';
	DECLARE ingredient_record RECORD;
	BEGIN			
        SELECT b.name INTO beer FROM Beers b WHERE b.id =  _beerID;

        IF beer IS NOT NULL THEN
	        FOR ingredient_record IN (SELECT i.name, i.itype
						FROM Ingredients i
						JOIN Contains c ON (c.ingredient = i.id)
						WHERE c.beer = _beerID
                        GROUP BY i.name, i.itype)
            LOOP ingredients_list := ingredients_list || ' ' || ingredient_record.name || ' (' ||ingredient_record.itype || ')' || CHR(10) || '  ';
            END LOOP;

			IF ingredients_list <> ' ' 
            THEN beer := beer || CHR(10) || ' contains: ' ||  CHR(10) || ' ' || ingredients_list;
            ELSE beer := beer || CHR(10) || '  no ingredients recorded'; 
            END IF;
 
        ELSE beer := 'No such beer (' || _beerID || ')';
        END IF;
        RETURN beer; 
	END;
	$$ LANGUAGE plpgsql;

--------Q8)
DROP TYPE IF EXISTS BeerHops CASCADE;
CREATE TYPE BeerHops AS (beer text, brewery text, hops text);
CREATE OR REPLACE FUNCTION Q8(pattern text) 
    RETURNS SETOF Beerhops AS
	$$
	DECLARE beer_info BeerHops;
	BEGIN
		FOR beer_info IN (
            SELECT DISTINCT b.name AS beer,
				CASE
                    WHEN COUNT(DISTINCT br.id) > 1 THEN string_agg( br.name, '+' ORDER BY br.name)
					ELSE MAX(br.name)
				END AS brewery,
				CASE
                    WHEN COUNT(i.itype) = 0 THEN 'no hops recorded'
					ELSE string_agg(i.name, ',' ORDER BY i.name)
				END AS hops
			FROM Beers b
			JOIN Brewed_by brb ON (brb.beer = b.id)
			JOIN Breweries br ON (brb.brewery = br.id)
			LEFT JOIN Contains c ON (c.beer = b.id)
			LEFT JOIN Ingredients i ON (c.ingredient = i.id AND i.itype = 'hop')
			WHERE b.name ILIKE '%' || pattern || '%' 
			GROUP  BY b.name
		)
        LOOP
		RETURN NEXT beer_info;
		END loop;
		RETURN;
	END;
	$$ LANGUAGE plpgsql;

--------Q9)
DROP TYPE IF EXISTS Collab cascade;
CREATE TYPE Collab AS (brewery text, collaborator text);
CREATE OR REPLACE FUNCTION Q9(breweryID integer) 
	RETURNS SETOF Collab AS
	$$
	DECLARE 
        brewery_name text;
	    collab_count integer;
		collab text;
	BEGIN
		SELECT br.name INTO brewery_name FROM Breweries br 
        WHERE breweryID = br.id;

	    IF brewery_name IS NULL THEN
        RETURN NEXT ROW('No such brewery (' || breweryID || ')', 'none') :: Collab;
        RETURN;
		END IF;

        SELECT COUNT(*) INTO collab_count FROM Brewed_by WHERE beer IN (
            SELECT id FROM Beers WHERE id IN (
                SELECT beer FROM Brewed_by WHERE brewery = breweryID
            ) AND id IN (
                SELECT beer FROM Brewed_by WHERE brewery != breweryID
            )
        );

        IF collab_count = 0 THEN
            RETURN NEXT (brewery_name, 'none') :: Collab;
        END IF;

        RETURN NEXT(brewery_name, (SELECT name FROM Breweries WHERE id = (
            SELECT DISTINCT brewery FROM Brewed_by WHERE beer IN (
                SELECT id FROM Beers WHERE id IN (
                    SELECT beer FROM Brewed_by WHERE brewery = breweryID
                ) AND id IN (
                    SELECT beer FROM Brewed_by WHERE brewery != breweryID
                )
            ) ORDER BY brewery DESC LIMIT 1
        )));

        FOR collab IN (
            SELECT DISTINCT brewery FROM Brewed_by WHERE beer IN (
                SELECT id FROM Beers WHERE id IN (
                    SELECT beer FROM Brewed_by WHERE brewery = breweryID
                ) AND id IN (
                    SELECT beer FROM Brewed_by WHERE brewery != breweryID
                )
            ) AND brewery != breweryID
        ) LOOP
			RETURN NEXT ROW (NULL, (SELECT name FROM Breweries WHERE id = collab::integer)::text):: Collab;
        END LOOP;

        RETURN;
		END;
		$$ LANGUAGE plpgsql;