-- export ygoprodeck data to `cards.json`.
COPY(
SELECT  card.*
FROM
(
	SELECT  UNNEST(data) AS card
	FROM READ_JSON_AUTO
	( './build-resources/tmp/cards.json', maximum_object_size = 104857600
	)
) ) TO './build-resources/tmp/cards.parquet' (FORMAT 'PARQUET');