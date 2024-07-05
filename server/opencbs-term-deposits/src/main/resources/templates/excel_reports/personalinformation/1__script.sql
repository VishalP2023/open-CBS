select jsonb_agg(t.*)
from (
    select
        row_number() over ()                    id
      , tt.*
    from (
        select
          analytic.profile_name                 profile_name
        , analytic.profile_type                 profile_type
        , loans.code                            loan_code
        , loans.disbursement_date               disbursement_date
        , analytic.planned_close_date           close_date
        , loans.amount                          amount
        , analytic.olb                          olb
        , analytic.loan_officer_name            loan_officer
        , analytic.loan_product_name            loan_product
        , product.code                          product_code
        , coalesce(guarantor_profiles.name, '') guarantor
        , coalesce(guarantors.amount, 0)        guarantor_amount
        , coalesce(collaterals.name, '')        collaterals
        , coalesce(collaterals.amount, 0)       collaterals_amount
        , apps.grace_period           			    grace_period
        , apps.maturity               			    maturity
        , apps.interest_rate          			    interest_rate
        , analytic.late_days          			    late_days
        , coalesce(group_profiles.name, '')	    group_name
        , analytic.branch_name        			    branch
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_1.value, '')  else coalesce(companies_fields_values_1.value, '')  end custom_field_1
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_2.value, '')  else coalesce(companies_fields_values_2.value, '')  end custom_field_2
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_3.value, '')  else coalesce(companies_fields_values_3.value, '')  end custom_field_3
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_4.value, '')  else coalesce(companies_fields_values_4.value, '')  end custom_field_4
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_5.value, '')  else coalesce(companies_fields_values_5.value, '')  end custom_field_5
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_6.value, '')  else coalesce(companies_fields_values_6.value, '')  end custom_field_6
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_7.value, '')  else coalesce(companies_fields_values_7.value, '')  end custom_field_7
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_8.value, '')  else coalesce(companies_fields_values_8.value, '')  end custom_field_8
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_9.value, '')  else coalesce(companies_fields_values_9.value, '')  end custom_field_9
        , case when analytic.profile_type = 'PERSON' then coalesce(people_fields_values_10.value, '') else coalesce(companies_fields_values_10.value, '') end custom_field_10
      from
        analytics_active_loans analytic
      inner join
        loans
          on analytic.loan_id = loans.id
      inner join
        loan_applications apps
          on apps.id = loans.loan_application_id
      inner join
          loan_products product
            on product.id = analytic.loan_product_id
      left join
        guarantors
          on guarantors.loan_application_id = apps.id
      left join
        profiles guarantor_profiles
          on guarantor_profiles.id = guarantors.profile_id
      left join
        collaterals
          on collaterals.loan_application_id = apps.id
      left join
        groups_members groups
          on groups.member_id = analytic.profile_id
      left join
        profiles group_profiles
          on group_profiles.id = groups.group_id

      left join
        people_custom_fields_values people_fields_values_1
          on people_fields_values_1.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_1.field_id = 1
      left join
        custom_fields people_fields_1
          on people_fields_1.id = people_fields_values_1.field_id

      left join
        people_custom_fields_values people_fields_values_2
          on people_fields_values_2.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_2.field_id = 2
      left join
        custom_fields people_fields_2
          on people_fields_2.id = people_fields_values_2.field_id

      left join
        people_custom_fields_values people_fields_values_3
          on people_fields_values_3.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_3.field_id = 3
      left join
        custom_fields people_fields_3
          on people_fields_3.id = people_fields_values_3.field_id

      left join
        people_custom_fields_values people_fields_values_4
          on people_fields_values_4.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_4.field_id = 4
      left join
        custom_fields people_fields_4
          on people_fields_4.id = people_fields_values_4.field_id

      left join
        people_custom_fields_values people_fields_values_5
          on people_fields_values_5.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_5.field_id = 5
      left join
        custom_fields people_fields_5
          on people_fields_5.id = people_fields_values_5.field_id

      left join
        people_custom_fields_values people_fields_values_6
          on people_fields_values_6.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_6.field_id = 6
      left join
        custom_fields people_fields_6
          on people_fields_6.id = people_fields_values_6.field_id

      left join
        people_custom_fields_values people_fields_values_7
          on people_fields_values_7.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_7.field_id = 7
      left join
        custom_fields people_fields_7
          on people_fields_7.id = people_fields_values_7.field_id

      left join
        people_custom_fields_values people_fields_values_8
          on people_fields_values_8.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_8.field_id = 8
      left join
        custom_fields people_fields_8
          on people_fields_8.id = people_fields_values_8.field_id

      left join
        people_custom_fields_values people_fields_values_9
          on people_fields_values_9.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_9.field_id = 9
      left join
        custom_fields people_fields_9
          on people_fields_9.id = people_fields_values_9.field_id

      left join
        people_custom_fields_values people_fields_values_10
          on people_fields_values_10.owner_id = analytic.profile_id
            and analytic.profile_type = 'PERSON' and people_fields_values_10.field_id = 10
      left join
        custom_fields people_fields_10
          on people_fields_10.id = people_fields_values_10.field_id



      left join
        companies_custom_fields_values companies_fields_values_1
          on companies_fields_values_1.owner_id = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_1.field_id = 1
      left join
        custom_fields companies_fields_1
          on companies_fields_1.id = companies_fields_values_1.field_id

      left join
        companies_custom_fields_values companies_fields_values_2
          on companies_fields_values_2.owner_id  = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_2.field_id = 2
      left join
        custom_fields companies_fields_2
          on companies_fields_2.id = companies_fields_values_2.field_id

      left join
        companies_custom_fields_values companies_fields_values_3
          on companies_fields_values_3.owner_id  = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_3.field_id = 3
      left join
        custom_fields companies_fields_3
          on companies_fields_3.id = companies_fields_values_3.field_id

      left join
        companies_custom_fields_values companies_fields_values_4
          on companies_fields_values_4.owner_id  = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_4.field_id = 4
      left join
        custom_fields companies_fields_4
          on companies_fields_4.id = companies_fields_values_4.field_id

      left join
        companies_custom_fields_values companies_fields_values_5
          on companies_fields_values_5.owner_id  = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_5.field_id = 5
      left join
        custom_fields companies_fields_5
          on companies_fields_5.id = companies_fields_values_5.field_id

      left join
        companies_custom_fields_values companies_fields_values_6
          on companies_fields_values_6.owner_id  = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_6.field_id = 6
      left join
        custom_fields companies_fields_6
          on companies_fields_6.id = companies_fields_values_6.field_id

      left join
        companies_custom_fields_values companies_fields_values_7
          on companies_fields_values_7.owner_id  = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_7.field_id = 7
      left join
        custom_fields companies_fields_7
          on companies_fields_7.id = companies_fields_values_7.field_id

      left join
        companies_custom_fields_values companies_fields_values_8
          on companies_fields_values_8.owner_id  = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_8.field_id = 8
      left join
        custom_fields companies_fields_8
          on companies_fields_8.id = companies_fields_values_8.field_id

      left join
        companies_custom_fields_values companies_fields_values_9
          on companies_fields_values_9.owner_id  = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_9.field_id = 9
      left join
        custom_fields companies_fields_9
          on companies_fields_9.id = companies_fields_values_9.field_id

      left join
        companies_custom_fields_values companies_fields_values_10
          on companies_fields_values_10.owner_id  = analytic.profile_id
            and analytic.profile_type = 'COMPANY' and companies_fields_values_10.field_id = 1
      left join
        custom_fields companies_fields_10
          on companies_fields_10.id = companies_fields_values_10.field_id
      where
        cast(analytic.calculated_date as date) = cast(:ddate as date)
          and (analytic.branch_id = :branchId or :branchId = 0)
          and (analytic.loan_officer_id = :userId or :userId = 0)
      ) tt
  ) t;