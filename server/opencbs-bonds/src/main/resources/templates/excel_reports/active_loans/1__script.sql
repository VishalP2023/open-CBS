select jsonb_agg(t.*)
from (
    select
        row_number() over ()                    id
      , tt.*
    from (
        with analytic as
        (
          select * from analytics_active_loans
        )
        select
            analytic.loan_product_name          group_field
          , count(analytic.loan_id)             loans
          , count(analytic_person.loan_id)      loan_persons
          , count(analytic_company.loan_id)     loan_company
          , count(distinct analytic.profile_id) profiles
          , sum(analytic.olb)                   olb
        from
          analytic
        left join
          analytic analytic_person
            on analytic_person.id = analytic.id
               and analytic_person.profile_type = 'PERSON'
        left join
          analytic analytic_company
            on analytic_company.id = analytic.id
               and analytic_company.profile_type = 'COMPANY'
        where
          cast(analytic.calculated_date as date) = cast(:ddate as date)
            and (analytic.branch_id = :branchId or :branchId = 0)
            and (analytic.loan_products_currency_id = :currencyId or :currencyId = 0)
            and (analytic.loan_officer_id = :userId or :userId = 0)
        group by
          analytic.loan_product_name
      ) tt
  ) t;