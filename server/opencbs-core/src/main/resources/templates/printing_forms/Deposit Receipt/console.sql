select jsonb_agg(t.*)
 from
   (
     select
        ae.amount                               amount,
        ae.description                          description,
        p.name                                  customer,
        u.first_name || ' ' || u.last_name      teller,
        a2.number                               number,
        ae.effective_at                         date,
        p2.name                                 profile
       from accounting_entries ae
        inner join accounting_entries_tills a on ae.id = a.accounting_entries_id and a.operation_type = 'DEPOSIT'
        left join profiles p on a.initiated_by = p.id
        left join tills t2 on a.till_id = t2.id
        left join till_events event2 on t2.id = event2.till_id
        left join users u on event2.teller_id = u.id
        left join accounts a2 on ae.credit_account_id = a2.id
        inner join profiles_accounts pa on a2.id = pa.account_id
        inner join profiles p2 on pa.profile_id = p2.id
       where ae.id = :contractId
   ) t;