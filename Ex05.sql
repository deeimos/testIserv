/*
    5. ��������� ������� ����� ����� ���������� �� ������ ����� �� ������ ������ �� ��� �����, ���
       ����� ������ ���� �������, ������ � ��������
*/

declare @columns nvarchar(MAX), @sql nvarchar(MAX);

select @columns = coalesce(@columns + ', ', '') + quotename(N_Month)
from (select distinct format([D_Date], 'yyyyMM') as N_Month from dbo.FD_Bills) as months;

set @sql = N'
    select *
    from (
        select
            format([D_Date], ''yyyyMM'') as N_Month,
            [C_Sale_Items],
            [N_Amount]
        from dbo.FD_Bills
    ) as SourceData
    pivot (
        sum([N_Amount])
        for N_Month IN (' + @columns + ')
    ) as PivotData
    order by [C_Sale_Items];
';

exec sp_executesql @sql;
