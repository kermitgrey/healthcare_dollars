OPTIONS(DIRECT=TRUE, SKIP=1, SILENT=FEEDBACK)
LOAD DATA
INFILE '/your-file-path/PGYR2016_P06302020.csv'
INFILE '/your-file-path/PGYR2017_P06302020.csv'
INFILE '/your-file-path/PGYR2018_P06302020.csv'
INFILE '/your-file-path/PGYR2019_P06302020.csv'
APPEND
INTO TABLE PAY_PAYMENTS_LOAD
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  CHANGE_TYPE,
  COVERED_RECIPIENT_TYPE,
  TEACHING_HOSPITAL_CCN,
  TEACHING_HOSPITAL_ID,
  TEACHING_HOSPITAL_NAME,
  PHYSICIAN_PROFILE_ID,
  PHYSICIAN_FIRST_NAME,
  PHYSICIAN_MIDDLE_NAME,
  PHYSICIAN_LAST_NAME,
  PHYSICIAN_NAME_SUFFIX,
  RECIPIENT_PRIMARY_BUSINESS_STREET_ADDRESS_LINE1,
  RECIPIENT_PRIMARY_BUSINESS_STREET_ADDRESS_LINE2,
  RECIPIENT_CITY,
  RECIPIENT_STATE,
  RECIPIENT_ZIP_CODE,
  RECIPIENT_COUNTRY,
  RECIPIENT_PROVINCE,
  RECIPIENT_POSTAL_CODE,
  PHYSICIAN_PRIMARY_TYPE,
  PHYSICIAN_SPECIALTY CHAR(300),
  PHYSICIAN_LICENSE_STATE_CODE1,
  PHYSICIAN_LICENSE_STATE_CODE2,
  PHYSICIAN_LICENSE_STATE_CODE3,
  PHYSICIAN_LICENSE_STATE_CODE4,
  PHYSICIAN_LICENSE_STATE_CODE5,
  SUBMITTING_APPLICABLE_MANUFACTURER_OR_APPLICABLE_GPO_NAME,
  APPLICABLE_MANUFACTURER_OR_APPLICABLE_GPO_MAKING_PAYMENT_ID,
  APPLICABLE_MANUFACTURER_OR_APPLICABLE_GPO_MAKING_PAYMENT_NAME,
  APPLICABLE_MANUFACTURER_OR_APPLICABLE_GPO_MAKING_PAYMENT_STATE,
  APPLICABLE_MANUFACTURER_OR_APPLICABLE_GPO_MAKING_PAYMENT_COUNTRY,
  TOTAL_AMOUNT_OF_PAYMENT_USDOLLARS,
  DATE_OF_PAYMENT,
  NUMBER_OF_PAYMENTS_INCLUDED_IN_TOTAL_AMOUNT,
  FORM_OF_PAYMENT_OR_TRANSFER_OF_VALUE,
  NATURE_OF_PAYMENT_OR_TRANSFER_OF_VALUE,
  CITY_OF_TRAVEL,
  STATE_OF_TRAVEL,
  COUNTRY_OF_TRAVEL,
  PHYSICIAN_OWNERSHIP_INDICATOR,
  THIRD_PARTY_PAYMENT_RECIPIENT_INDICATOR,
  NAME_OF_THIRD_PARTY_ENTITY_RECEIVING_PAYMENT_OR_TRANSFER_OF_VALUE,
  CHARITY_INDICATOR,
  THIRD_PARTY_EQUALS_COVERED_RECIPIENT_INDICATOR,
  CONTEXTUAL_INFORMATION CHAR(500),
  DELAY_IN_PUBLICATION_INDICATOR,
  RECORD_ID,
  DISPUTE_STATUS_FOR_PUBLICATION,
  RELATED_PRODUCT_INDICATOR,
  COVERED_OR_NONCOVERED_INDICATOR_1,
  INDICATE_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_1,
  PRODUCT_CATEGORY_OR_THERAPEUTIC_AREA_1,
  NAME_OF_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_1,
  ASSOCIATED_DRUG_OR_BIOLOGICAL_NDC_1,
  COVERED_OR_NONCOVERED_INDICATOR_2,
  INDICATE_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_2,
  PRODUCT_CATEGORY_OR_THERAPEUTIC_AREA_2,
  NAME_OF_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_2,
  ASSOCIATED_DRUG_OR_BIOLOGICAL_NDC_2,
  COVERED_OR_NONCOVERED_INDICATOR_3,
  INDICATE_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_3,
  PRODUCT_CATEGORY_OR_THERAPEUTIC_AREA_3,
  NAME_OF_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_3,
  ASSOCIATED_DRUG_OR_BIOLOGICAL_NDC_3,
  COVERED_OR_NONCOVERED_INDICATOR_4,
  INDICATE_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_4,
  PRODUCT_CATEGORY_OR_THERAPEUTIC_AREA_4,
  NAME_OF_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_4,
  ASSOCIATED_DRUG_OR_BIOLOGICAL_NDC_4,
  COVERED_OR_NONCOVERED_INDICATOR_5,
  INDICATE_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_5,
  PRODUCT_CATEGORY_OR_THERAPEUTIC_AREA_5,
  NAME_OF_DRUG_OR_BIOLOGICAL_OR_DEVICE_OR_MEDICAL_SUPPLY_5,
  ASSOCIATED_DRUG_OR_BIOLOGICAL_NDC_5,
  PROGRAM_YEAR,
  PAYMENT_PUBLICATION_DATE
)