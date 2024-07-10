select jsonb_agg(t.*)
from (
    select
        row_number() over ()              id
      , tt.*
    from (


       SELECT
            ae.created_at as    created_at,
            coalesce(p.name, '')                   as profile_name,
            coalesce(v.name, '')                   as vault_name,
            ae.amount as                           amount,
            coalesce(ae.extra ->> 'type', 'Other') as type,
            cur.name as currency_name,
            ae.description as description,
            usr.first_name || ' ' || usr.last_name AS user_name
          FROM
            tills_accounts ta
          INNER JOIN
            accounting_entries ae ON ae.credit_account_id = ta.account_id
                                   OR ae.debit_account_id = ta.account_id

          LEFT JOIN
             users usr ON usr.id = ae.created_by_id

          LEFT JOIN
            profiles_accounts pa
                ON pa.account_id = ae.credit_account_id
                OR pa.account_id = ae.debit_account_id

          LEFT JOIN
            vaults_accounts va
                ON va.account_id = ae.credit_account_id
                OR va.account_id = ae.debit_account_id

          LEFT JOIN
            accounts a ON a.id = ta.account_id

          LEFT JOIN
            profiles p ON p.id = pa.profile_id

          LEFT JOIN vaults v ON v.id = va.vault_id

          LEFT JOIN currencies cur ON a.currency_id = cur.id

        WHERE
          ta.till_id = :tillId
          AND cast(:ddate as date) + time'00:00:01' <= cast(ae.created_at as timestamp) AND cast(ae.created_at as timestamp) <= cast(:ddate as date) + time'23:59:59'
        ORDER BY
          created_at

      ) tt
  ) t;
