select jsonb_agg(t.*)
from (
    select
        row_number() over ()                             id
      , tt.*
    from (
            select
              loans.code                   loan_code
            , analitycs.profile_name       profile_name
            , analitycs.loan_officer_name  loan_officer_name
            , analitycs.disbursement_date  start_date
            , analitycs.planned_close_date end_date
            , loans.amount                 amount
            , loans.amount - analitycs.principal paid_principal
            , analitycs.principal          olb
            , analitycs.late_principal     late_principal
            , analitycs.late_interest      late_interest
            , analitycs.penalty_due        penalty_due
            , analitycs.late_days          late_days
          from
              loans
          inner join
            analytics_active_loans analitycs
              on analitycs.loan_id = loans.id
                 and cast(analitycs.calculated_date as date) = cast(:ddate as date)
                 and (analitycs.branch_id = :branchId or :branchId = 0)
                 and (analitycs.loan_officer_id = :userId or :userId = 0)
                 and (analitycs.loan_products_currency_id = :currencyId or :currencyId = 0)
                 and analitycs.late_days > 0
      ) tt
  ) t;