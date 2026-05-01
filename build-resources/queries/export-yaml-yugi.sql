-- export yaml-yugi data to `yaml-yugi.parquet`.
INSTALL yaml
FROM community; LOAD yaml; COPY
(
	SELECT  *
	FROM READ_YAML('./build-resources/tmp/yaml-yugi-master/data/cards/*.yaml', sample_size=-1, maximum_sample_files=-1)
) TO './build-resources/tmp/yaml-yugi.parquet' (FORMAT 'PARQUET');