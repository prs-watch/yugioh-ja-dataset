-- export japanese datase of yugioh to `dataset.parquet`.
COPY(
WITH LINKMARKER_MAP AS
(
	SELECT  MAP(LIST(en),LIST(ja)) AS m
	FROM READ_JSON_AUTO
	('./build-resources/maps/linkmarker-map.json'
	)
)
SELECT  C.id                                                                                 AS id
       ,C.name                                                                               AS name_en
       ,C.desc                                                                               AS text_en
       ,REGEXP_REPLACE( REGEXP_REPLACE(Y.name.ja,'<rt>[^<]*</rt>','','g'),'<[^>]*>','','g' ) AS name_ja
       ,CONCAT( IF(Y.pendulum_effect.ja IS NOT NULL,'[テキスト]\n',''),REGEXP_REPLACE( REGEXP_REPLACE(Y.text.ja,'<rt>[^<]*</rt>','','g'),'<[^>]*>','','g' ),IF( Y.pendulum_effect.ja IS NOT NULL,'\n\n[ペンデュラムテキスト]\n','' ),REGEXP_REPLACE( REGEXP_REPLACE(Y.pendulum_effect.ja,'<rt>[^<]*</rt>','','g'),'<[^>]*>','','g' ) ) AS text_ja
       ,T.ja                                                                                 AS type
       ,FT.ja                                                                                AS frame_type
       ,C.atk                                                                                AS atk
       ,C.def                                                                                AS def
       ,C.level                                                                              AS level
       ,R.ja                                                                                 AS race
       ,A.ja                                                                                 AS attribute
       ,C.scale                                                                              AS scale
       ,C.linkval                                                                            AS linkval
       ,LIST_TRANSFORM( C.linkmarkers,lambda x: COALESCE(LINKMARKER_MAP.m [x],x) )           AS linkmarkers
FROM './build-resources/tmp/cards.parquet' C
LEFT OUTER JOIN './build-resources/tmp/yaml-yugi.parquet' Y
ON ( C.name = Y.name.en OR CAST(C.id AS VARCHAR) = CAST(Y.password AS VARCHAR) )
LEFT OUTER JOIN './build-resources/maps/type-map.json' T
ON C.type = T.en
LEFT OUTER JOIN './build-resources/maps/frame-type-map.json' FT
ON C.frameType = FT.en
LEFT OUTER JOIN './build-resources/maps/race-map.json' R
ON C.race = R.en
LEFT OUTER JOIN './build-resources/maps/attribute-map.json' A
ON C.attribute = A.en
CROSS JOIN LINKMARKER_MAP
WHERE C.type != 'Skill Card' ) TO 'dataset.parquet' (FORMAT 'PARQUET');