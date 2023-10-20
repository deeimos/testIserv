/*
    8. Требуется вывести номер и дату всех родительских документов, документа с номером 4-д/1, с
       сортировкой по дате
*/

select
        DD_Docs.[C_Number],
        DD_Docs.[D_Date]
    from dbo.DD_Docs 
        inner join
                (
                    select
                            [LINK],
                            [C_Number],
                            [D_Date],
                            [F_Docs]
                        from dbo.DD_Docs
                        where right([C_Number], 3)  = 'д/1' and [F_Docs] > 0
                ) as SecondTable
            on  DD_Docs.[LINK] = SecondTable.[F_Docs]
    order by DD_Docs.[D_Date]