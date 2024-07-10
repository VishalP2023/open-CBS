select jsonb_agg(t.*)
from (
    select
        row_number() over ()              id
      , tt.*
    from (
        select
          loans.code                      code
        , cast(analytic.disbursement_date as date) disbursement_date
        , cast(analytic.planned_close_date as date) planned_close_date
        , analytic.profile_name           profile_name
        , analytic.loan_officer_name      loan_officer_name
        , analytic.branch_name            branch_name
        , loans.amount                    amount
        , analytic.interest               interest
        , analytic.olb                    olb
        , analytic.late_days              late_days
      from
        analytics_active_loans analytic
      inner join loans
        on (analytic.loan_id = loans.id
           and cast(analytic.calculated_date as date) = cast(:ddate as date))
      where
          (analytic.branch_id = :branchId or :branchId = 0)
      and (analytic.loan_officer_id = :userId or :userId = 0)
      ) tt
  ) t;