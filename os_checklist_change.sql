declare @edate date = '2021-10-31';
declare @bank varchar(20) = 'bank name here'; --this can assume different values
set @bank=concat(@bank,'%');
declare @bdate date=datefromparts(year(@edate),month(@edate),1);

declare @table Table (
payment_type varchar(255)
,description varchar(255)
,amount decimal(25,2)
);


----checks----
insert into @table
select
'01. checks'
,'01. beginning balance'
,coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Computer check','Manual check')
and chk.check_date<@bdate
and (chk.cleared_date is null or chk.cleared_date>=@bdate)
and (chk.voided_date is null or chk.voided_date>=@bdate)
;

insert into @table
select
'01. checks'
,'02. voided'
,-coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Computer check','Manual check')
and chk.check_date<=@edate
and chk.cleared_date is null 
and chk.voided_date between @bdate and @edate
;

insert into @table
select
'01. checks'
,'03. written'
,coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Computer check','Manual check')
and chk.check_date between @bdate and @edate
;

insert into @table
select
'01. checks'
,'04. paid'
,-coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Computer check','Manual check')
and chk.cleared_date between @bdate and @edate
;

insert into @table
select
'01. checks'
,'05. ending balance'
,coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Computer check','Manual check')
and chk.check_date<@edate
and (chk.cleared_date is null or chk.cleared_date>=@edate)
and (chk.voided_date is null or chk.voided_date>=@edate)
;


----efts----
insert into @table
select
'02. efts' [payment type]
,'01. beginning balance' [description]
,coalesce(sum(chk.amount),0) [amount]
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('EFT check')
and chk.check_date<@bdate
and (chk.cleared_date is null or chk.cleared_date>=@bdate)
and (chk.voided_date is null or chk.voided_date>=@bdate)
;

insert into @table
select
'02. efts'
,'02. voided'
,-coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('EFT check')
and chk.check_date<=@edate
and chk.cleared_date is null 
and chk.voided_date between @bdate and @edate

insert into @table
select
'02. efts'
,'03. written'
,coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('EFT check')
and chk.check_date between @bdate and @edate

insert into @table
select
'02. efts'
,'04. paid'
,-coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('EFT check')
and chk.cleared_date between @bdate and @edate
;

insert into @table
select
'02. efts'
,'05. ending balance'
,coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('EFT check')
and chk.check_date<@edate
and (chk.cleared_date is null or chk.cleared_date>=@edate)
and (chk.voided_date is null or chk.voided_date>=@edate)
;

--wires--
insert into @table
select
'03. wires' [payment type]
,'01. beginning balance' [description]
,coalesce(sum(chk.amount),0) [amount]
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Bank draft')
and chk.check_date<@bdate
and (chk.cleared_date is null or chk.cleared_date>=@bdate)
and (chk.voided_date is null or chk.voided_date>=@bdate)
;

insert into @table
select
'03. wires'
,'02. voided'
,-coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Bank draft')
and chk.check_date<=@edate
and chk.cleared_date is null 
and chk.voided_date between @bdate and @edate
;

insert into @table
select
'03. wires'
,'03. written'
,coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Bank draft')
and chk.check_date between @bdate and @edate
;

insert into @table
select
'03. wires'
,'04. paid'
,-coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Bank draft')
and chk.cleared_date between @bdate and @edate
;

insert into @table
select
'03. wires'
,'05. ending balance'
,coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_type in ('Bank draft')
and chk.check_date<@edate
and (chk.cleared_date is null or chk.cleared_date>=@edate)
and (chk.voided_date is null or chk.voided_date>=@edate)
;

insert into @table
select
'04. totals' [payment type]
,'01. beginning balance' [description]
,coalesce(sum(chk.amount),0) [amount]
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_date<@bdate
and (chk.cleared_date is null or chk.cleared_date>=@bdate)
and (chk.voided_date is null or chk.voided_date>=@bdate)
;

insert into @table
select
'04. totals'
,'02. voided'
,-coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_date<=@edate
and chk.cleared_date is null 
and chk.voided_date between @bdate and @edate
;

insert into @table
select
'04. totals'
,'03. written'
,coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_date between @bdate and @edate
;

insert into @table
select
'04. totals'
,'04. paid'
,-coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.cleared_date between @bdate and @edate
;

insert into @table
select
'04. totals'
,'05. ending balance'
,coalesce(sum(chk.amount),0)
from acctetl.dbo.uo_check chk
join acctetl.dbo.uo_bank bnk ON bnk.bank_id = chk.bank_id
where
bnk.account_id like @bank
and chk.check_date<@edate
and (chk.cleared_date is null or chk.cleared_date>=@edate)
and (chk.voided_date is null or chk.voided_date>=@edate)
;


select * from @table
order by 1,2
;
