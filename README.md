# healthcare_dollars

<h2> Financial Relationships in Health Care </h2>

<p> The Centers for Medicare and Medicaid (CMS) has developed a system to
track any payments (or transfers-of-value) that arise between pharmaceutical 
companies (and others) and physicians. CMS makes the raw data available to the 
public on its website for those interested in making use of it.  I have utilized a 
subset of the CMS data and prepared an analysis that describes the nature of 
those financial relationships.  You can read the analysis at 
<link> https://www.prontezza.com<link>.</p>

<p>The above analysis uses data stored in an Oracle database.  This repo contains the 
code to create the necessary schema objects and make the data ready for use in the
analysis.  Here you will find the following:</p>

<ul>
<li> ddl to create the necessary tables and indexes</li>
<li> scripts to import the data into the database tables</li>
<li> database package to transform the data in the staging tables</li> 
</ul>

<h3> DDL </h3>

<p> The following scripts create the necessary schema objects:</p>

<ol>
<li>OpenPay-createTables.sql: Creates the staging, fact, and
    dimension tables.</li>
<li>OpenPay-createIndex.sql: Generates a index on the general payments 
    staging table.</li>
</ol>

<h3>Import Scripts for Oracle's SqlLoader utility</h3>

<p> The following scripts load the data files into oracle tables: </p>

<ol>
<li>OpenPay-sqlloadr-doctors.ctl: Loads physician profile information
    into a staging table.</li>
<li>OpenPay-sqlloadr-payment-detail.ctl: Loads the annual general payments 
    files (2016-2019) into a staging table.</li>
<li>OpenPay-sqlloadr-states.ctl: Loads the Census Bureau states file into
    a dimension table.</li>
<li>OpenPay-sqlloadr-taxonomy.ctl: Loads the physician specialty information
    from NUCC into a dimension table.
</ol>

<h3> Database Package</h3>

<p>The database package pay_pak, in the file OpenPay-createPkg.sql, contains all
   the procedures and functions needed to transform and add the data to the
   destination tables.  A brief description of the procedures is provided below:</p>

<ol>
<li>create_doctors: Reads the physician profile information in the staging table
    to create a result set of U.S. domiciled physicians.  It then adds it to the 
    destination dimension table.</li>
<li>create_payments: Reads the general payments staging table and generates a
    summary of payments by doctor, payor, paytype, and year for all U.S. domiciled
    physicians and adds the data to the fact table.</li>
<li>create_payors: Reads the general payments staging table and produces a list
    of companies that made payments to U.S. domiciled physicians, removes duplicates,
    and adds the result set to the dimension table.</li>
<li>create_pay_types: Reads the general payments staging table and produces a list
    of unique pay types that describes the nature of payments made.  It also uses a 
    function to create a shortened version of the pay type label and inserts both into the
    dimension table.</li>
</ol>

<p>The source data files used in the analysis can be downloaded from their respective website source:</p>

<ul>
<li>General Payments Detail data for 2016-2019 and the Physician Profile
Supplement all from CMS at <link>https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads</link></li>
<li>Health Care Provider Taxonomy from the National Uniform Claim
Committee at <link> https://nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57</link>
</li>
</ul>

<p>The only other file used in the analysis is the United States state code file and 
that is provided here (CensusBureau-US-States.txt).</p>
