# healthcare_dollars

<h2> Financial Relationships in Health Care </h2>

<p> The Centers for Medicare and Medicaid (CMS) has developed a system to
track any payments (or transfers-of-value) that arise between pharmaceutical 
companies (and others) and physicians. CMS makes the raw data available to the 
public on its website for those interested in making use of it.  I have utilized a 
subset of the CMS data and prepared an analysis that describes the nature of 
those financial relationships.  You can read the analysis at 
<link> https://www.prontezza.com/healthcare-dollars</link>.</p>

<p>This repo contains the code used to create the needed schema objects
that supported my analysis using an Oracle 12c database.  Here you will find 
the following:</p>

<ul>
<li> ddl to create the necessary tables and indexes.</li>
<li> sql loader code to load the data into the database tables.</li>
<li> PL/SQL package needed to process the data in the staging tables and load it into the destination tables.</li> 
</ul>

<p> The following steps outline the process followed to build
everything necessary to support the data analysis:</p>

<ol>
<li>Execute the .sql scripts to create tables and the
    pl/sql database package.</li>

<li>Use sqlloader to upload the data using each
   of the *.ctl files. </li>

<li>Execute the .sql script to create the staging table index.</li>

<li>Execute procedure pay_create_doctors: this populates
   the pay_doctors table with information on physicians
   staged in the pay_doctors_load table.</li>

<li>Execute procedure pay_create_pay_types: this populates
   the pay_pay_types table which contains the 15 categories 
   that describes the nature of each payment made.  It
   reads the staging table pay_payments_load and 
   serves as a look-up table to relate an old pay
   type description to new pay type description. 
   After execution, manually update the 'newpaytype' 
   field using a pay type description of choice.</li>

<li>Execute procedure pay_create_payors: this fills the pay_payors
   table holding the companies making payments.  It uses 
   the data in the staging table pay_payments_load.</li>

<li>Execute procedure pay_create_payments: this builds summary payments
   data using the data in the pay_payments_load table 
   and stores it in the table pay_payments.</li>

<li>Execute procedure pay_update_payor_bins and pay_update_doctor_bins:
   Each of these assigns a bin label to a payor or doctor
   based on their cumulative payment sums and updates the
   pay_payors and pay_doctors tables respectively.</li>
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
that is provided here in the repo (CensusBureau-US-States.txt).</p>

