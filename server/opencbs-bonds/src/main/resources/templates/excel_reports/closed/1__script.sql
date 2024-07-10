select jsonb_agg(t.*)
from (
    select
        row_number() over ()                             id
      , tt.*
    from (
      with closed_date as
      (
        select
            effective_at
          , loan_id
        from
          loans_events
        where event_type = 'CLOSED'
          and cast(effective_at as date) between cast(:startDate as date) and cast(:endDate as date)
      )

      select
          cast(closed_date.effective_at as date) close_date
        , profiles.name            profile_name
        , loans.code               loan_code
        , loans.amount             loan_amount
        , products.name            product_name
        , cast(users.first_name as text) || ' ' || cast(users.last_name as text) loan_officer_name
        , cast(loans.disbursement_date as date) disbursement_date
        , currencies.name          currency_name
      from loans
      inner join loan_applications apps
        on apps.id = loans.loan_application_id
      inner join profiles
        on profiles.id = apps.profile_id
      inner join loan_products products
        on products.id = apps.loan_product_id
      inner join users
        on users.id = apps.created_by_id
          and (users.branch_id = :branchId or :branchId = 0)
          and (users.id = :userId or :userId = 0)
      inner join currencies
        on products.currency_id = currencies.id
          and (currencies.id = :currencyId or :currencyId = 0)
      inner join closed_date
        on closed_date.loan_id = loans.id
      order by closed_date.effective_at, profiles.name
        ) tt
  ) t;