/*
    3. “ребуетс€ вывести услугу и среднюю сумму начислений за все врем€, у которой средн€€ сумма
       превышает 120 р.
*/

select 
        [C_Sale_Items],
        sum([N_Amount])/count([C_Sale_Items])
    from dbo.FD_Bills
    group by ([C_Sale_Items])
    having (sum([N_Amount]) / count([C_Sale_Items]) > 120)