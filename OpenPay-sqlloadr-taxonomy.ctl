-- sqlldr has a max size of 255 char and will error out if col data exceeds it.
-- insert a char(size) definition to override the default 255.
-- if not will get the error "field in datafile exceeds maximum length" for that column

OPTIONS (SILENT=FEEDBACK, DIRECT=TRUE, SKIP=1)
LOAD DATA
INFILE '/your-file-path/nucc_taxonomy_201.csv'
INTO TABLE pay_taxonomy
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(CODE,
GROUPING        "SUBSTR(:GROUPING, 1, 99)",
CLASSIFICATION  "SUBSTR(:CLASSIFICATION, 1, 99)",
SPECIALIZATION  "SUBSTR(:SPECIALIZATION, 1, 99)",
DEFINITION      CHAR(4000) "SUBSTR(:DEFINITION, 1, 99)",
NOTES           CHAR(4000) "SUBSTR(:NOTES, 1, 99)"
)
