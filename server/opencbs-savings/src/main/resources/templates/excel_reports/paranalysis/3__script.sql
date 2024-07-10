select jsonb_agg(t.*)
from (
    select
        row_number() over ()                    id
      , tt.*
    from (
        with analytic as
        (
          select * from analytics_active_loans analytic
          where
            cast(analytic.calculated_date as date) = cast(:ddate as date)
              and (analytic.branch_id = :branchId or :branchId = 0)
              and (analytic.loan_products_currency_id = :currencyId or :currencyId = 0)
              and (analytic.loan_officer_id = :userId or :userId = 0)
        )
          , only_late_loans as
        (
          select * from analytic
          where analytic.late_days > 0
        )
          , source_table as
        (
            select
                group_table.name                                                                                  group_field
              , sum(case when late_loans.late_days > 0 then late_loans.olb else 0 end)                            par
              , sum(case when late_loans.late_days > 30 then late_loans.olb else 0 end)                           par_30
              , sum(analytic.olb)                                                                                 olb
              , round(sum(case when late_loans.late_days > 0 then late_loans.late_principal else 0 end)
                / sum(analytic.olb), 2)                                                                           parolb
              , round(sum(case when late_loans.late_days > 30 then late_loans.olb else 0 end)
                / sum(analytic.olb), 2)                                                                           par30olb
              , count(distinct late_loans.profile_id)                                                             profile_count_late
              , count(distinct late_loans.profile_id)                                                             loans_count_late
              , sum(case when late_loans.late_days > 30 then 1 else 0 end)                                        profile_30
              , sum(case when analytic.late_days > 30 then 1 else 0 end)                                          loan_30
              , sum(case when late_loans.late_days between 1 and 30 then late_loans.late_principal else 0 end)    par_1_30
              , sum(case when late_loans.late_days between 1 and 30 then 1 else 0 end)                            profile_1_30
              , sum(case when analytic.late_days between 1 and 30 then 1 else 0 end)                              loan_1_30
              , sum(case when late_loans.late_days between 31 and 60 then late_loans.late_principal else 0 end)   par_31_60
              , sum(case when late_loans.late_days between 31 and 60 then 1 else 0 end)                           profile_31_60
              , sum(case when analytic.late_days between 31 and 60 then 1 else 0 end)                             loan_31_60
              , sum(case when late_loans.late_days between 61 and 90 then late_loans.late_principal else 0 end)   par_61_90
              , sum(case when late_loans.late_days between 61 and 90 then 1 else 0 end)                           profile_61_90
              , sum(case when analytic.late_days between 61 and 90 then 1 else 0 end)                             loan_61_90
              , sum(case when late_loans.late_days between 91 and 180 then late_loans.late_principal else 0 end)  par_91_180
              , sum(case when late_loans.late_days between 91 and 180 then 1 else 0 end)                          profile_91_180
              , sum(case when analytic.late_days between 91 and 180 then 1 else 0 end)                            loan_91_180
              , sum(case when late_loans.late_days between 181 and 365 then late_loans.late_principal else 0 end) par_181_365
              , sum(case when late_loans.late_days between 181 and 365 then 1 else 0 end)                         profile_181_365
              , sum(case when analytic.late_days between 181 and 365 then 1 else 0 end)                           loan_181_365
              , sum(case when late_loans.late_days > 365 then late_loans.late_principal else 0 end)               par_365
              , sum(case when late_loans.late_days > 365 then 1 else 0 end)                                       profile_365
              , sum(case when analytic.late_days > 365 then 1 else 0 end)                                         loan_365
            from
              analytic
            left join
              only_late_loans late_loans on analytic.id = late_loans.id
            left join
              loan_products group_table on group_table.id = analytic.loan_product_id
            group by
              group_table.name, group_table.id
        )
        select
            group_field
          , par
          , par_30
          , olb
          , parolb
          , par30olb
          , par_1_30
          , par_31_60
          , par_61_90
          , par_91_180
          , par_181_365
          , par_365
        from(
              select
                  1 order_id
                , group_field
                , par
                , par_30
                , olb
                , parolb
                , par30olb
                , par_1_30
                , par_31_60
                , par_61_90
                , par_91_180
                , par_181_365
                , par_365
              from
                source_table
              union all
              select
                  2 order_id
                , 'Profiles'
                , profile_count_late
                , profile_30
                , olb
                , parolb
                , par30olb
                , profile_1_30
                , profile_31_60
                , profile_61_90
                , profile_91_180
                , profile_181_365
                , profile_365
              from
                source_table
              union all
              select
                  3 order_id
                , 'Loans'
                , loans_count_late
                , loan_30
                , olb
                , parolb
                , par30olb
                , loan_1_30
                , loan_31_60
                , loan_61_90
                , loan_91_180
                , loan_181_365
                , loan_365
              from
                source_table
            ) t
        order by order_id
      ) tt
  ) t;