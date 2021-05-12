OPTIONS (SILENT=FEEDBACK, DIRECT=TRUE, SKIP=1)
LOAD DATA
INFILE '/your-file-path/statefips.csv'
INTO TABLE pay_states
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
statefips,
statecode,
statename,
statens
)
