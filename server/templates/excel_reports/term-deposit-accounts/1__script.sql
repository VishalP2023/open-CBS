select jsonb_agg(t.*)
from (
       select
         p.name                                                                            customer_name,
         tda.code,
         product.name                                                                      product_name,
         to_char(tda.open_date, 'DD-MM-YYYY')                                              open_date,
         tda.term_agreement                                                                term,
         tda.amount                                                                        amount,
         to_char(tda.close_date, 'DD-MM-YYYY')                                             close_date,
         (select *
          from get_balance(a1.account_id :: bigint, :date :: timestamp without time zone)) interest
       from term_deposits tda
         left join term_deposit_products product on tda.term_deposit_product_id = product.id
         left join profiles p on tda.profile_id = p.id
         left join term_deposit_accounts a1 on tda.id = a1.term_deposit_id and a1.type = 'INTEREST_ACCRUAL'
       where tda.status = 'OPEN'
	group by customer_name, tda.code, product_name, open_date, term, amount, close_date, interest) t;
