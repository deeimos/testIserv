/*
    2. ��������� ������� ���������� ����� ���������� �� ������ ��� �� ��� �����
*/

select 
        distinct [N_Amount]
    from dbo.FD_Bills
    where [C_Sale_Items] = '���'