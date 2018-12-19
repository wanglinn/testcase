\timing on
-- $ID$
-- TPC-H/TPC-R Order Priority Checking Query (Q4)
-- Functional Query Definition
-- Approved February 1998

select
	o_orderpriority,
	count(*) as order_count
from
	orders
where
	o_orderdate >=  '1995-05-01'
	and o_orderdate < date '1997-03-02' + interval '3' month
	and exists (
		select
			*
		from
			lineitem
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority;
