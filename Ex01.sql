/*
    1.  ��������� �������� ������, ������� ������� �����, ������� ����, ���� � �������
        �����.�����.��� � ����� ��������� �� ���� ���� ������, � ������� ���� ���������� �
        ���������� �� 8 �� 12 ������������.
*/

select
        FD_Bills.[C_Number],
        SD_Subscrs.[C_Number] as C_Subscr,
        format([D_Date], 'dd.MM.yyyy') as formattedDate,
        [N_Amount]
    from dbo.FD_Bills
		inner join dbo.SD_Subscrs
			on FD_Bills.F_Subscr = SD_Subscrs.LINK
	where day([D_Date]) between 8 and 12
    group by FD_Bills.[C_Number], SD_Subscrs.[C_Number], D_Date, N_Amount
	order by [D_Date] desc
	offset 0 rows fetch next 2 rows only