select jsonb_agg(t.*)
 from
   (
     with loan_id as (
       select min(loan_id) loan_id from loans_events where group_key = :contractId
     ) 
     , olb as (
       select loans_events.loan_id, amount - (
         select sum(amount) from loans_events
         inner join loan_id on loan_id.loan_id = loans_events.loan_id
         where event_type = 'REPAYMENT_OF_PRINCIPAL'
       ) olb from loans_events
        inner join loan_id on loan_id.loan_id = loans_events.loan_id
        where event_type = 'DISBURSEMENT'
     )
     select
       l.code                                     loan_code,
       pr.name                                    customer,
       us.username                                cashier,
       olb.olb                                    olb,
       le.principal                               principal,
       le.interest                                interest,
       le.penalty                                 penalty,
       to_char(le.date, 'DD-Mon-YYYY')            "date",
       coalesce(le.principal, 0) + coalesce(le.interest, 0) + coalesce(le.penalty, 0)  total_amount

     from (
            select
              group_key,
              loan_id,
              sum(case when le.event_type = 'REPAYMENT_OF_PRINCIPAL'
                then le.amount end) principal,
              sum(case when le.event_type = 'REPAYMENT_OF_INTEREST'
                then le.amount end) interest,
              sum(case when le.event_type = 'REPAYMENT_OF_PENALTY'
                then le.amount end) penalty,
              max(le.effective_at)  date
            from loans_events le
            where group_key = :contractId
            group by group_key, loan_id) le
       left join loans l on le.loan_id = l.id
       left join loan_applications a on l.loan_application_id = a.id
       left join profiles pr on a.profile_id = pr.id
       left join users us on us.id = l.created_by_id
     left join olb on olb.loan_id = l.id
   ) t;
