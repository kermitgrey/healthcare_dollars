OPTIONS (SILENT=FEEDBACK, DIRECT=TRUE, SKIP=1)
LOAD DATA
INFILE '/your-file-path/PRFL_SPLMTL_P06302020.csv'
INTO TABLE pay_doctors_load
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
Physician_Profile_ID,  
Physician_Profile_First_Name,  
Physician_Profile_Middle_Name,  
Physician_Profile_Last_Name,  
Physician_Profile_Suffix,  
Physician_Profile_Alternate_First_Name,  
Physician_Profile_Alternate_Middle_Name,  
Physician_Profile_Alternate_Last_Name,  
Physician_Profile_Alternate_Suffix,  
Physician_Profile_Address_Line_1,  
Physician_Profile_Address_Line_2,  
Physician_Profile_City,  
Physician_Profile_State,  
Physician_Profile_Zipcode,  
Physician_Profile_Country_Name,  
Physician_Profile_Province_Name,  
Physician_Profile_Primary_Specialty,  
Physician_Profile_OPS_Taxonomy_1,  
Physician_Profile_OPS_Taxonomy_2,  
Physician_Profile_OPS_Taxonomy_3,  
Physician_Profile_OPS_Taxonomy_4,  
Physician_Profile_OPS_Taxonomy_5,  
Physician_Profile_License_State_Code_1,  
Physician_Profile_License_State_Code_2,  
Physician_Profile_License_State_Code_3,  
Physician_Profile_License_State_Code_4,  
Physician_Profile_License_State_Code_5
)
