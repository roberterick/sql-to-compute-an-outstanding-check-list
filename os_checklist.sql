declare @edate date = '2021-10-31';
declare @bank varchar(20) = 'bank name here'; --this can assume different values

with cte as (
select
bnk.account_id
,chk.check_type
,chk.check_number
,chk.payee_name
,chk.check_date
,coalesce(cast(chk.cleared_date as char),'') cleared_date
,coalesce(cast(chk.voided_date as char),'') voided_date
,sum(chk.amount) amount
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
chk.check_date<=@edate
and bnk.account_id=@bank
and (chk.cleared_date is null or chk.cleared_date>=@edate)
and (chk.voided_date is null or chk.voided_date>=@edate)
group by
bnk.account_id
,chk.check_type
,chk.check_number
,chk.payee_name
,chk.check_date
,chk.cleared_date
,chk.voided_date
,chk.reverse_post_date
)

select * from cte
order by 1,2,3,5
;
