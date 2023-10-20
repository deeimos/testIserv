/*
    1.  “ребуетс€ написать запрос, который выведет номер, лицевой счет, дату в формате
        Ђдень.мес€ц.годї и сумму ближайших по дате двух счетов, у которых день начислени€ в
        промежутке от 8 до 12 включительно.
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