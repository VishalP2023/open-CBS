select jsonb_agg(t.*)
from (
    select
        row_number() over ()                             id
      , tt.*
    from (
          select distinct on (expected_date, loan_code)
              installment.maturity_date   expected_date
            , profiles.name               profile_name
            , loans.code                  loan_code
            , cast(users.first_name as varchar) || ' ' || cast(users.last_name as varchar)  loan_officer_name
            , loans.amount                amount
            , installment.olb             olb
            , installment.principal       principal
            , installment.interest        interest
            , installment.principal + installment.interest total
          from
            loans
          inner join
          (
            select actual_installments.*
            from loans_installments actual_installments
              inner join (
                           select max(id) id
                           from loans_installments
                           where deleted = false
                           group by number, loan_id
                         ) i on i.id = actual_installments.id
            where principal + interest > paid_interest + paid_principal
            order by loan_id, number
          ) installment on loans.id = installment.loan_id
          inner join loan_applications apps
            on apps.id = loans.loan_application_id
          inner join profiles
            on profiles.id = apps.profile_id
          inner join users
            on users.id = loans.loan_officer_id
          inner join loan_products products
            on products.id = apps.loan_product_id
          where
                (cast(installment.maturity_date as date) between cast(:startDate as date) and cast(:endDate as date))
            and (users.branch_id = :branchId or :branchId = 0)
            and (loans.loan_officer_id = :userId or :userId = 0)
            and (products.currency_id = :currencyId or :currencyId = 0)
          order by
            expected_date
        ) tt
  ) t;