select jsonb_agg(t.*)
from (
    select
        row_number() over ()                             id
      , tt.*
    from (
        select distinct
           loans.code                                    loan_code
         , products.name                                 loan_product
         , profiles.name                                 profile_name
         , users.first_name || ' ' || users.last_name as loan_officer_name
         , branches.name                                 branch_name
         , cast(loans.disbursement_date as date)         disbursed_at
         , loans.amount                                  loan_amount
         , coalesce(analytics.total_interest::varchar(255), '')         loan_interest
         , coalesce(fees.feesAmount, 0)                  fees_amount
        from loans
           inner join loan_applications loan_apps
             on (loan_application_id = loan_apps.id
                 and cast(loan_apps.disbursement_date as date) between cast(:startDate as date) and cast(:endDate as date))
           inner join loan_products products
             on (loan_apps.loan_product_id = products.id
                 and (products.currency_id = :currencyId or :currencyId = 0))
           inner join users
             on (users.id = loans.created_by_id
                 and (users.id = :userId or :userId = 0))
           inner join branches
             on (branches.id = users.branch_id
                 and (branches.id = :branchId or :branchId = 0))
           inner join profiles
             on (profiles.id = loan_apps.profile_id)
           left join (
                       select
                         sum(amount) feesAmount
                         , loan_application_id
                       from loan_applications_entry_fees
                       group by loan_application_id
                     ) fees on fees.loan_application_id = loan_apps.id
           left join analytics_active_loans analytics
             on analytics.loan_id = loans.id
           order by loans.disbursement_date
      ) tt
  ) t;