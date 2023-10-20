/*
    2. Требуется вывести уникальные суммы начислений по услуге ХВС за все время
*/

select 
        distinct [N_Amount]
    from dbo.FD_Bills
    where [C_Sale_Items] = 'ХВС'