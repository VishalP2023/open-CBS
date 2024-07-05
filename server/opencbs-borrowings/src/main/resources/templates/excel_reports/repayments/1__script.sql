
select jsonb_agg(t.*)
from (
    select
        row_number() over ()                    id
      , tt.*
    from (
        with principal as
        (
            select
                loan_id
              , group_key
              , coalesce(sum(amount), 0) amount
            from loans_events
            where event_type = 'REPAYMENT_OF_PRINCIPAL'
            group by loan_id, group_key
        )
          , interest as
        (
            select
                loan_id
              , group_key
              , coalesce(sum(amount), 0) amount
            from loans_events
            where event_type = 'REPAYMENT_OF_INTEREST'
            group by loan_id, group_key
        )
          , penalty as
        (
            select
                loan_id
              , group_key
              , coalesce(sum(amount), 0) amount
            from loans_events
            where event_type = 'REPAYMENT_OF_PENALTY'
            group by loan_id, group_key
        )
          , fee as
        (
            select
                loan_id
              , group_key
              , coalesce(sum(amount), 0) amount
            from loans_events
            where event_type = 'OTHER_FEE_REPAY'
            group by loan_id, group_key
        )

        select
            cast(events.effective_at as date)          repayment_date
          , loans.code                                 loan_code
          , profiles.name                              profile_name
          , users.first_name || ' ' || users.last_name officer_name
          , products.name                              product_name
          , branches.name                              branch_name
          , coalesce(principal.amount, 0)              principal_amount
          , coalesce(interest.amount, 0)               interest_amount
          , coalesce(penalty.amount, 0)                penalty_amount
          , coalesce(fee.amount, 0)                    fee
          , coalesce(principal.amount, 0)
            + coalesce(interest.amount, 0)
            + coalesce(penalty.amount, 0)
            + coalesce(fee.amount, 0)                  total
        from
          (
            select
                events.group_key
              , events.loan_id
              , events.created_by_id
              , events.effective_at
            from
              loans_events events
            where
                deleted = false
              and events.event_type in ('REPAYMENT_OF_PRINCIPAL', 'REPAYMENT_OF_INTEREST', 'REPAYMENT_OF_PENALTY', 'OTHER_FEE_REPAY')
              and cast(events.effective_at as date) between cast(:startDate as date) and cast(:endDate as date)
            group by events.group_key, events.loan_id, events.created_by_id, events.effective_at
          ) as events
        inner join loans
          on loans.id = events.loan_id
        inner join loan_applications application
          on application.id = loans.loan_application_id
        inner join profiles
          on profiles.id = application.profile_id
        inner join users
          on (users.id = events.created_by_id
            and (users.id = :userId or :userId = 0))
        inner join loan_products products
          on (products.id = application.loan_product_id
            and (products.currency_id = :currencyId or :currencyId = 0))
        inner join branches
          on (branches.id = users.branch_id
            and (branches.id = :branchId or :branchId = 0))
        inner join loan_applications apps
          on apps.id = loans.loan_application_id
--         left join loan_applications_entry_fees fees
--           on fees.loan_application_id = apps.id
        left join principal
          on principal.group_key = events.group_key and events.loan_id = principal.loan_id
        left join interest
          on interest.group_key = events.group_key and events.loan_id = interest.loan_id
        left join penalty
          on penalty.group_key = events.group_key and events.loan_id = penalty.loan_id
        left join fee
          on fee.group_key = events.group_key and events.loan_id = fee.loan_id
        order by events.effective_at, events.loan_id
      ) tt
  ) t;