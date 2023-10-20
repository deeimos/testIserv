/*
    4. ��������� ������� ����� ����� ���������� �� ������ ����� �� ������ ������ �� ��� ����� �
       ����������� �� �������, � ��� �������.

	   �� ���������� ����������� �������� ��� ������
*/

select
        format([D_Date], 'yyyyMM') as N_Month,
        [C_Sale_Items],
        sum([N_Amount]) as N_Amount_Sum
    from dbo.FD_Bills
	group by rollup (format([D_Date], 'yyyyMM'), [C_Sale_Items]) 
	order by N_Month, [C_Sale_Items]; 

