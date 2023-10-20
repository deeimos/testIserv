/*
    7. ��������� ������� ������ ����������, ���������� ������ ���������, ����������� ��
       ��������� ������.
       � ������� ������� �������., ����� ���������, ���� � ������� ����.�����.���
*/

select
        SD_Subscrs.[C_SecondName] + ' ' + substring(SD_Subscrs.[C_FirstName], 1, 1) as FIO,
        DD_Docs.[C_Number],
        format(DD_Docs.[D_Date], 'dd.MM.yyyy') as D_Date
    from dbo.DD_Docs
        inner join dbo.SD_Subscrs
            on  DD_Docs.[F_Subscr] = SD_Subscrs.[LINK]
    where       SD_Subscrs.[C_Address] like '�. ���������, ��-��. ������%'
            and year(getdate()) - year(SD_Subscrs.[D_BirthDate]) > 18