with OrderedBills as (
    select
        [D_Date],
        [C_Number],
        [N_Amount],
        lag([N_Amount]) over (order by [D_Date]) as N_Amount_B
    from
        dbo.FD_Bills
)
select
    [D_Date],
    [C_Number],
    [N_Amount],
	N_Amount_B
from
    OrderedBills
where
    [N_Amount] > isnull(N_Amount_B, 0)
order by
    [D_Date];
