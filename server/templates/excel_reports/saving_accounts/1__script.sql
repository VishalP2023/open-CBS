select jsonb_agg(t.*)
from (
  select
  p.name                                                                            customer_name,
  s.code,
  product.name                                                                      product_name,
  to_char(s.open_date, 'DD-MM-YYYY') open_date,
  (select *
   from get_balance(a.account_id :: bigint, :date :: timestamp without time zone))  balance,
  (select *
   from get_balance(a1.account_id :: bigint, :date :: timestamp without time zone)) interest,
  pcfv.value                                                                        membership_id,
  loc.name                                                                          home_village,
  prof.name                                                                         coop_name,
  pcfv4.value                                                                       gender
from savings s
  left join saving_products product on s.saving_product_id = product.id
  left join profiles p on s.profile_id = p.id
  left join savings_accounts a on s.id = a.saving_id and a.type = 'SAVING'
  left join savings_accounts a1 on s.id = a1.saving_id and a1.type = 'INTEREST'
  left join people_custom_fields_values pcfv on p.id = pcfv.owner_id and pcfv.field_id = 33 -- membership_id
  left join people_custom_fields_values pcfv2 on p.id = pcfv2.owner_id and pcfv2.field_id = 13 -- home_village
    left join locations loc on loc.id = cast(pcfv2.value as bigint)
  left join people_custom_fields_values pcfv3 on p.id = pcfv3.owner_id and pcfv3.field_id = 27 -- coop_name
    left join professions prof on prof.id = cast(pcfv3.value as bigint)
  left join people_custom_fields_values pcfv4 on p.id = pcfv4.owner_id and pcfv4.field_id = 8 -- gender
where s.status = 'OPEN') t;