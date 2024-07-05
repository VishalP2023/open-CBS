select jsonb_agg(t.*)
from
    (
        select
            ae.description                         description,
            ae.amount                              amount,
            replace(
                replace(cash_words(replace(ae.amount :: varchar, '.', ',') :: varchar :: money), '  dollars and', ','),
                'cents', '')                       to_text,
            debit.name                             debit_name,
            debit.number                           debit_number,
            credit.name                            credit_name,
            credit.number                          credit_number,
            to_char(ae.effective_at, 'YYYY-MM-YY') date,
            u.first_name || u.last_name            created_by,
            to_char(now(), 'YYYY-MM-YY')           date_now
        from accounting_entries ae
            left join accounts credit on ae.credit_account_id = credit.id
            left join accounts debit on ae.debit_account_id = debit.id
            left join users u on ae.created_by_id = u.id
            left join accounting_entries_tills aet on ae.id = aet.accounting_entries_id
        where ae.id = :contractId
    ) t;