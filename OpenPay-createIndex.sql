CREATE INDEX pay_payments_load_indx ON pay_payments_load(physician_profile_id,
                                                         applicable_manufacturer_or_applicable_gpo_making_payment_id,
                                                         nature_of_payment_or_transfer_of_value,
                                                         program_year);
