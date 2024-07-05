select jsonb_agg(t.*)
from (
    with analytic as
    (
        select
          analytic.*
          , loans.amount
        from
          analytics_active_loans analytic
          inner join
          loans
            on loans.id = analytic.loan_id
    )
      , result as
    (
        select
            count(analytic_10000.loan_id)                 Loans_10000
          , count(analytic_10000.profile_id)              Profiles_10000
          , count(analytic_10000_person.loan_id)          Loan_Persons_10000
          , count(analytic_10000_company.loan_id)         Loan_Company_10000
          , coalesce(sum(analytic_10000.olb), 0)          OLB_10000
          , count(analytic_20000.loan_id)                 Loans_20000
          , count(analytic_20000.profile_id)              Profiles_20000
          , count(analytic_20000_person.loan_id)          Loan_Persons_20000
          , count(analytic_20000_company.loan_id)         Loan_Company_20000
          , coalesce(sum(analytic_20000.olb), 0)          OLB_20000
          , count(analytic_50000.loan_id)                 Loans_50000
          , count(analytic_50000.profile_id)              Profiles_50000
          , count(analytic_50000_person.loan_id)          Loan_Persons_50000
          , count(analytic_50000_company.loan_id)         Loan_Company_50000
          , coalesce(sum(analytic_50000.olb), 0)          OLB_50000
          , count(analytic_100000.loan_id)                Loans_100000
          , count(analytic_100000.profile_id)             Profiles_100000
          , count(analytic_100000_person.loan_id)         Loan_Persons_100000
          , count(analytic_100000_company.loan_id)        Loan_Company_100000
          , coalesce(sum(analytic_100000.olb), 0)         OLB_100000
          , count(analytic_500000.loan_id)                Loans_500000
          , count(analytic_500000.profile_id)             Profiles_500000
          , count(analytic_500000_person.loan_id)         Loan_Persons_500000
          , count(analytic_500000_company.loan_id)        Loan_Company_500000
          , coalesce(sum(analytic_500000.olb), 0)         OLB_500000
          , count(analytic_1000000.loan_id)               Loans_1000000
          , count(analytic_1000000.profile_id)            Profiles_1000000
          , count(analytic_1000000_person.loan_id)        Loan_Persons_1000000
          , count(analytic_1000000_company.loan_id)       Loan_Company_1000000
          , coalesce(sum(analytic_1000000.olb), 0)        OLB_1000000
          , count(distinct analytic.profile_id)           Profiles
          , coalesce(sum(analytic.olb), 0)                OLB
        from
          analytic
        left join
          analytic analytic_10000
            on analytic_10000.id = analytic.id
               and analytic_10000.amount <= 10000
        left join
          analytic analytic_10000_person
            on analytic_10000_person.id = analytic_10000.id
               and analytic_10000_person.profile_type = 'PERSON'
        left join
          analytic analytic_10000_company
            on analytic_10000_company.id = analytic_10000.id
               and analytic_10000_company.profile_type = 'COMPANY'
        left join
          analytic analytic_20000
            on analytic_20000.id = analytic.id
               and analytic_20000.amount > 10000 and analytic_20000.amount <= 20000
        left join
          analytic analytic_20000_person
            on analytic_20000_person.id = analytic_20000.id
               and analytic_20000_person.profile_type = 'PERSON'
        left join
          analytic analytic_20000_company
            on analytic_20000_company.id = analytic_20000.id
               and analytic_20000_company.profile_type = 'COMPANY'
        left join
          analytic analytic_50000
            on analytic_50000.id = analytic.id
               and analytic_50000.amount > 20000 and analytic_50000.amount <= 50000
        left join
          analytic analytic_50000_person
            on analytic_50000_person.id = analytic_50000.id
               and analytic_50000_person.profile_type = 'PERSON'
        left join
          analytic analytic_50000_company
            on analytic_50000_company.id = analytic_50000.id
               and analytic_50000_company.profile_type = 'COMPANY'
        left join
          analytic analytic_100000
            on analytic_100000.id = analytic.id
               and analytic_100000.amount > 50000 and analytic_100000.amount <= 100000
        left join
          analytic analytic_100000_person
            on analytic_100000_person.id = analytic_100000.id
               and analytic_100000_person.profile_type = 'PERSON'
        left join
          analytic analytic_100000_company
            on analytic_100000_company.id = analytic_100000.id
               and analytic_100000_company.profile_type = 'COMPANY'
        left join
          analytic analytic_500000
            on analytic_500000.id = analytic.id
               and analytic_500000.amount > 100000 and analytic_500000.amount <= 500000
        left join
          analytic analytic_500000_person
            on analytic_500000_person.id = analytic_500000.id
               and analytic_500000_person.profile_type = 'PERSON'
        left join
          analytic analytic_500000_company
            on analytic_500000_company.id = analytic_500000.id
               and analytic_500000_company.profile_type = 'COMPANY'
        left join
          analytic analytic_1000000
            on analytic_1000000.id = analytic.id
               and analytic_1000000.amount > 500000
        left join
          analytic analytic_1000000_person
            on analytic_1000000_person.id = analytic_1000000.id
               and analytic_1000000_person.profile_type = 'PERSON'
        left join
          analytic analytic_1000000_company
            on analytic_1000000_company.id = analytic_1000000.id
               and analytic_1000000_company.profile_type = 'COMPANY'
        where
              (cast(analytic.calculated_date as date) = cast(:ddate as date))
          and (analytic.branch_id = :branchId or :branchId = 0)
          and (analytic.loan_products_currency_id = :currencyId or :currencyId = 0)
          and (analytic.loan_officer_id = :userId or :userId = 0)
    )

    select
        0                           id
      , '0 - 10000'                 group_field
      , result.Loans_10000          loans
      , result.Loan_Persons_10000   loan_persons
      , result.Loan_Company_10000   loan_company
      , result.Profiles_10000       profiles
      , result.OLB_10000            olb
    from
      result

    union all

    select
        1                         id
      , '10000 - 20000'           group_field
      , result.Loans_20000        loans
      , result.Loan_Persons_20000 loan_persons
      , result.Loan_Company_20000 loan_company
      , result.Profiles_20000     profiles
      , result.OLB_20000          olb
    from
      result

    union all

    select
        2                          id
      , '20000 - 50000'            group_field
      , result.Loans_50000         loans
      , result.Loan_Persons_50000  loan_persons
      , result.Loan_Company_50000  loan_company
      , result.Profiles_50000      profiles
      , result.OLB_50000           olb
    from
      result

    union all

    select
        3                          id
      , '50000 - 100000'           group_field
      , result.Loans_100000        loans
      , result.Loan_Persons_100000 loan_persons
      , result.Loan_Company_100000 loan_company
      , result.Profiles_100000     profiles
      , result.OLB_100000          olb
    from
      result

    union all

    select
        4                           id
      , '100000 - 500000'           group_field
      , result.Loans_500000         loans
      , result.Loan_Persons_500000  loan_persons
      , result.Loan_Company_500000  loan_company
      , result.Profiles_500000      profiles
      , result.OLB_500000           olb
    from
      result

    union all

    select
        5                           id
      , '> 500000'                  group_field
      , result.Loans_1000000        loans
      , result.Loan_Persons_1000000 loan_persons
      , result.Loan_Company_1000000 loan_company
      , result.Profiles_1000000     profiles
      , result.OLB_1000000          olb
    from
      result
) t;