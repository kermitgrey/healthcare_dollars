CREATE OR REPLACE PACKAGE pay_openpays
AS
procedure pay_create_doctors;

procedure pay_create_payments;

procedure pay_create_payors;

procedure pay_create_pay_types;

procedure pay_update_payor_bins;

procedure pay_update_doctor_bins;

function pay_get_doctor_name(namein IN VARCHAR2) RETURN varchar2; 

function pay_get_paytype(typeIn varchar2) RETURN number;

v_err_num           number;
v_err_msg          varchar2(250 char);

END pay_openpays;
/
CREATE OR REPLACE PACKAGE BODY pay_openpays
AS
/***********************************************************************************
** Populate the pay_doctors table with records in the doctors_load table.
** Select only doctors that have a U.S.A. state residence.
***********************************************************************************/
PROCEDURE pay_create_doctors
IS

BEGIN
    
    EXECUTE IMMEDIATE 'truncate table pay_doctors';
    
    INSERT INTO pay_doctors( docid,
                                                 first_name,
                                                  middle_name,
                                                  last_name,
                                                  full_name,
                                                  city,
                                                  state,
                                                  zipcode,
                                                  taxoncode,
                                                  profilespecialty)
    SELECT b.docid,
                    b.fname,
                    b.mname,
                    b.lname,
                    CASE WHEN b.mname IS NULL THEN b.lname||', '||b.fname
                    ELSE b.lname||', '||b.fname||' '||mname END,
                    b.city,
                    b.state,
                    b.zip,
                    b.taxon,
                    b.specialty
    FROM
        (SELECT a.physician_profile_id DOCID, 
                    pay_get_doctor_name(coalesce(a.physician_profile_first_name, a.physician_profile_alternate_first_name)) FName,
                    pay_get_doctor_name(coalesce(a.physician_profile_middle_name, a.physician_profile_alternate_middle_name)) MNAME,
                    pay_get_doctor_name(coalesce(a.physician_profile_last_name, a.physician_profile_alternate_last_name)) LNAME,
                    a.physician_profile_city AS City, 
                    a.physician_profile_state AS State, 
                    a.physician_profile_zipcode AS Zip, 
                    COALESCE(a.physician_profile_ops_taxonomy_1, a.physician_profile_ops_taxonomy_2, a.physician_profile_ops_taxonomy_3, a.physician_profile_ops_taxonomy_4, a.physician_profile_ops_taxonomy_5) AS TAXON,
                    a.physician_profile_primary_specialty AS Specialty
        FROM pay_doctors_load a
        WHERE EXISTS (SELECT 1
                                    FROM pay_states b
                                    WHERE b.statecode = a.physician_profile_state)) b;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      v_err_num := sqlcode;
      v_err_msg := substr(sqlerrm(v_err_num), 1, 250);
      
      INSERT INTO error_log(progname,
                              progtime,
                              errcode,
                              errmesg)
      VALUES('pay_create_doctors',
                sysdate,
                v_err_num,
                v_err_msg);
                
END pay_create_doctors;
/***********************************************************************************
** Populate the pay_payments table with records in the pay_payments_load table.
** Select only payments to doctors that reside in the pay_doctors table.
* * Uses fcn to convert nature_of_payment value to a paytypeid.  It should return
** a proper value.  But if no data is found, it returns the value 99.  As this does not
** exist in the foreign table, it will throw a FK exception.  This should not happen though
** as all records in that fk table are built from the original data in pay_payments_load
** table which is the basis for the insert here.
***********************************************************************************/
PROCEDURE pay_create_payments
AS

BEGIN

    EXECUTE IMMEDIATE 'truncate table pay_payments';
    
    INSERT INTO pay_payments(docid,
                                                        payorid,
                                                        paytypeid,
                                                        progyear,
                                                        amount,
                                                        loaddate)
    SELECT c.Docid,
                    c.PayorId,
                    pay_get_paytype(c.PayType) As PayTypeId,
                    c.PgmYr,
                    c.Total,
                    sysdate
    FROM	
        (SELECT a.physician_profile_id AS DocId,
                        a.applicable_manufacturer_or_applicable_gpo_making_payment_id AS PayorId,
                        a.nature_of_payment_or_transfer_of_value AS PayType,
                        a.program_year As PgmYr,
                        SUM(a.total_amount_of_payment_usdollars) AS Total
        FROM pay_payments_load a
        WHERE a.Covered_Recipient_Type = 'Covered Recipient Physician'
        AND EXISTS (SELECT 1
                                FROM pay_doctors b
                                WHERE b.DocId = a.Physician_Profile_ID)
        GROUP BY a.physician_profile_id,
                            a.applicable_manufacturer_or_applicable_gpo_making_payment_id,
                            a.nature_of_payment_or_transfer_of_value,
                            a.program_year) c;
        
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
      v_err_num := sqlcode;
      v_err_msg := substr(sqlerrm(v_err_num), 1, 250);
      
      INSERT INTO error_log(progname,
                              progtime,
                              errcode,
                              errmesg)
      VALUES('pay_create_payments',
                sysdate,
                v_err_num,
                v_err_msg);
END pay_create_payments;
/***********************************************************************************
** Populate the pay_payors table with payorid/payorname in the pay_payments_load table.
** Select only records of payments made to physicians and that reside in the USA; i.e.
** those in the pay_doctors table.
***********************************************************************************/
PROCEDURE pay_create_payors
AS
    
BEGIN

    EXECUTE IMMEDIATE 'truncate table pay_payors';
           
    INSERT INTO pay_payors(payorid,
                                                payorname)
    SELECT d.payorid,
                 UPPER(d.payorname)
    FROM
        (SELECT c.payorid,
                      c.payorname,
                      ROW_NUMBER() OVER(PARTITION BY c.payorid ORDER BY c.payorid) AS RNUM
        FROM
            (SELECT DISTINCT a.APPLICABLE_MANUFACTURER_OR_APPLICABLE_GPO_MAKING_PAYMENT_ID AS PayorId,
                   LOWER(a.APPLICABLE_MANUFACTURER_OR_APPLICABLE_GPO_MAKING_PAYMENT_NAME) As PayorName
            FROM pay_payments_load a
            WHERE a.Covered_Recipient_Type = 'Covered Recipient Physician'
            AND EXISTS( SELECT 1
                                    FROM pay_doctors b
                                    WHERE a.physician_profile_id = b.docid)) c ) d
    WHERE d.rnum =1;
        
    COMMIT;

EXCEPTION   
    WHEN OTHERS THEN
      v_err_num := sqlcode;
      v_err_msg := substr(sqlerrm(v_err_num), 1, 250);
      
      INSERT INTO error_log(progname,
                              progtime,
                              errcode,
                              errmesg)
      VALUES('pay_create_payors',
                sysdate,
                v_err_num,
                v_err_msg);
END pay_create_payors;
/***********************************************************************************
** Populate the pay_pay_types table with the unique nature_of_payment_or_transfer_of_value
** values from the pay_payments_load table.
** 
***********************************************************************************/
PROCEDURE pay_create_pay_types
AS

BEGIN
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE pay_pay_types'; 
    
    INSERT INTO pay_pay_types(oldpaytype,
                                                    newpaytype)
    SELECT DISTINCT nature_of_payment_or_transfer_of_value, 
                                    null
    FROM pay_payments_load;
 
    COMMIT;

EXCEPTION 
    WHEN OTHERS THEN
      v_err_num := sqlcode;
      v_err_msg := substr(sqlerrm(v_err_num), 1, 250);
      
      INSERT INTO error_log(progname,
                              progtime,
                              errcode,
                              errmesg)
      VALUES('pay_create_pay_types',
                sysdate,
                v_err_num,
                v_err_msg);

END pay_create_pay_types;

/***********************************************************************************
** Use a cursor to assign a group_bin label to every company. The group_bin serves
** to group the companies based on total $ spent provided in the pay_payments table.
** The cursor result is used to update the pay_payors table.
**
***********************************************************************************/
PROCEDURE pay_update_payor_bins
AS
    CURSOR payor_recs
    IS
    SELECT q1.payorid,
                      q1.payortotal,
                      NTILE(100) OVER (ORDER BY q1.payortotal) Deca
            FROM
            (SELECT payorid,
                            SUM(amount) payortotal
            FROM pay_payments
            GROUP BY payorid) q1;
        
BEGIN

    FOR rec in payor_recs LOOP    
        UPDATE pay_payors
        SET GROUPBIN = rec.deca
        WHERE payorid = rec.payorid;
        
        COMMIT;
        
    END LOOP
 
    COMMIT;

EXCEPTION 
    WHEN OTHERS THEN
      v_err_num := sqlcode;
      v_err_msg := substr(sqlerrm(v_err_num), 1, 250);
      
      INSERT INTO error_log(progname,
                              progtime,
                              errcode,
                              errmesg)
      VALUES('pay_update_payor_bins',
                sysdate,
                v_err_num,
                v_err_msg);

END pay_update_payor_bins;

/***********************************************************************************
** Use a cursor to assign a group_bin label to every doctor. The group_bin serves
** to group the doctors based on total $ amounts provided in the pay_payments table.
** The cursor result is used to update the pay_doctors table.
**
***********************************************************************************/
PROCEDURE pay_update_doctor_bins
AS
    CURSOR doctor_recs
    IS
    SELECT q1.docid,
                  q1.doctotal,
                  NTILE(100) OVER (ORDER BY q1.doctotal) Deca
    FROM
        (SELECT docid,
                        SUM(amount) doctotal
        FROM pay_payments
        GROUP BY docid) q1;
        
BEGIN

    FOR rec in doctor_recs LOOP    
        UPDATE pay_doctors
        SET GROUPBIN = rec.deca
        WHERE docid = rec.docid;

        COMMIT;
        
    END LOOP
 
    COMMIT;

EXCEPTION 
    WHEN OTHERS THEN
      v_err_num := sqlcode;
      v_err_msg := substr(sqlerrm(v_err_num), 1, 250);
      
      INSERT INTO error_log(progname,
                              progtime,
                              errcode,
                              errmesg)
      VALUES('pay_update_doctor_bins',
                sysdate,
                v_err_num,
                v_err_msg);

END pay_update_doctor_bins;

/*************************************************************************
* Fcn accepts a name in and transforms it into proper a format looking for 
* any existing spaces and hyphens to output the proper format.
**************************************************************************/
FUNCTION pay_get_doctor_name(namein IN VARCHAR2)
    RETURN VARCHAR2
    IS 
    fullname           VARCHAR2(35 CHAR);
    symbol              VARCHAR2(2 CHAR);

BEGIN
        IF INSTR(namein, '-', 1, 1) > 0 THEN
            symbol := '-';
        ELSE
            symbol := ' ';
        END IF;
    
        IF length(namein) IS NULL THEN 
                 fullname := NULL;
        ELSIF  length(namein) - length(replace(namein, symbol,'')) = 0 THEN
                fullname :=   UPPER(substr(namein, 1, 1))||LOWER(substr(namein, 2, length(namein)-1));
        ELSE
                fullname := UPPER(substr(namein, 1, 1))||
                                    LOWER(substr(namein, 2, INSTR(namein, symbol, 2, 1)-1))||
                                        UPPER(substr(namein, INSTR(namein, symbol, 1, 1)+1, 1))||
                                        LOWER(substr(namein, INSTR(namein, symbol, 1,1)+2, 99));
        END IF;
        
        RETURN (fullname);

END pay_get_doctor_name;

/***********************************************************************************
* Fcn accepts the nature_of_payment from the original payment record and converts
* it to an equivalent paytypeid stored in the pay_pay_types table.  This paytypeid is 
* then stored  with the whole record in the pay_payments records 
* (in lieu of the nature_of_payment).  If no record is found in pay_pay_types this
* fcn returns 99 value to calling proc.  This will cause the calling proc to throw a 
* foreign-key error upon insert into pay_payments table as 99 does not 
* exist in pay_pay_types table.
*
****************************************************************************/
FUNCTION pay_get_paytype(typeIn VARCHAR2)
    RETURN NUMBER
    IS
        paytype         NUMBER;

BEGIN
    
        SELECT paytypeid INTO paytype
        FROM pay_pay_types
        WHERE oldpaytype = typeIn;
        
        RETURN (paytype);
EXCEPTION
    WHEN no_data_found THEN
        paytype := 99;
        RETURN paytype;
        
END pay_get_paytype;

END pay_openpays;
/
