\timing on
-- $ID$
-- TPC-H/TPC-R Global Sales Opportunity Query (Q22)
-- Functional Query Definition
-- Approved February 1998


select
	cntrycode,
	count(*) as numcust,
	sum(c_acctbal) as totacctbal
from
	(
		select
			substring(c_phone from 1 for 2) as cntrycode,
			c_acctbal
		from
			customer
		where
			substring(c_phone from 1 for 2) not in
				('13-652-915-8939', '16-658-112-3221', '13-558-731-7204', '32-828-107-2832', '13-761-547-5974', '30-114-968-4951', '25-989-741-2988')
			and c_acctbal < (
				select
					avg(c_acctbal)
				from
					customer
				where
					c_acctbal > 0.00
					and substring(c_phone from 1 for 2) not in
						('13-652-915-8939', '16-658-112-3221', '13-558-731-7204', '32-828-107-2832', '13-761-547-5974', '3    0-114-968-4951', '25-989-741-2988')
						--('29-261-996-3120', '11-917-786-9955', '22-354-984-5361', '29-399-293-6241', '13-702-694-4520', '20-888-668-2668', '19-443-196-8008')
			)
			and not exists (
				select
					*
				from
					orders
				where
					o_custkey = c_custkey
			)
	) as custsale
group by
	cntrycode
order by
	cntrycode;

