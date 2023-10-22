/*
1.	��������� �������� �������� ��������� dbo.UI_FP_Payment_Split, ������� �� ��������� �������� � ������� dbo.FD_Payments
����� ���������� ��� �� ������ �� ���������� ������ � ������� ������ �� ����������� ����� � ������� dbo.FD_Bills. 
	�������� ��������� ��� �� ������ ������������� ������� � ������� dbo.FD_Bills.
	�������� ��������� ����� ����� ��� ���������, �� ������� � ��� �����������.
	��� ����������� ����� ��������� ��������:
	0	� �� ����, ������� � ����� ������ ������.
	1	� ��������������� �� ������ ������ � ������.

*/

create procedure dbo.UI_FP_Payment_Split
	@LINK int,
	@N_Type int
as
begin
	declare @TotalAmount money
	declare @UserLink int

	select @TotalAmount = N_Amount, @UserLink = F_Subscr
		from dbo.FD_Payments
	where [LINK] = @LINK

	-- �����������
	-- �� ����, ������� � ����� ������ ������
	declare @counter int = 1
	declare @MaxValue int = (select max(LINK) from FD_Bills) 
	if @N_Type = 0
		begin
		/*
			select max(dbo.FD_Bills.[LINK])
				from dbo.FD_Bills
					inner join dbo.FD_Payments
						on dbo.FD_Bills.[F_Subscr] = dbo.FD_Payments.[F_Subscr] */

			while @counter < @MaxValue and @TotalAmount > 0
				begin
					if @UserLink = (select F_Subscr
										from dbo.FD_Bills
									where [LINK] = @counter)
						begin
							declare @BillAmount money
							declare @SplitAmount money = 0

							select @BillAmount = N_Amount_Rest
								from dbo.FD_Bills
							where [LINK] = @counter

							if @BillAmount > 0
							begin
								if @BillAmount >= @TotalAmount
									begin
										set @SplitAmount = @TotalAmount
										set @TotalAmount = 0
									end
								else
									begin
										set @SplitAmount = @BillAmount
										set @TotalAmount = @TotalAmount - @BillAmount
									end
							
								update dbo.FD_Bills
									set [N_Amount_Rest] = @BillAmount - @SplitAmount
								where [LINK] = @counter

								insert into dbo.FD_Payment_Details([F_Payments], [F_Bills], [C_Sale_Items], [N_Amount])
								select @LINK, [LINK], [C_Sale_Items], @SplitAmount
									from dbo.FD_Bills
								where dbo.FD_Bills.[LINK] = @counter
							end
						end
					set @counter = @counter + 1
				end
		end

	-- ��������������� �� ������ ������ � ������
	else if @N_Type = 1
		begin
			declare @dtCounter date
			declare @dtLastDB date

			select @dtCounter = [D_Date]
				from dbo.FD_Bills
			where [LINK] = @counter

			select @dtLastDB = [D_Date]
				from dbo.FD_Bills
			where [LINK] = @MaxValue

			while @dtCounter <= @dtLastDB and @TotalAmount > 0
				begin
					declare @TotalRest money;
					select @TotalRest = sum(N_Amount_Rest)
						from dbo.FD_Bills
					where @UserLink = [F_Subscr] and  year([D_Date]) = year(@dtCounter) and month([D_Date]) = month(@dtCounter)
					
					print(@TotalRest)
					if(@TotalRest > @TotalAmount)
						begin
							update dbo.FD_Bills
								set [N_Amount_Rest] = [N_Amount] - round(@TotalAmount / @TotalRest * [N_Amount_Rest], 2)
							where @UserLink = [F_Subscr] and  year([D_Date]) = year(@dtCounter) and month([D_Date]) = month(@dtCounter)

							insert into dbo.FD_Payment_Details([F_Payments], [F_Bills], [C_Sale_Items], [N_Amount])
							select @LINK, [LINK], [C_Sale_Items], [N_Amount] - [N_Amount_Rest]
								from dbo.FD_Bills
							where @UserLink = [F_Subscr] and  year([D_Date]) = year(@dtCounter) and month([D_Date]) = month(@dtCounter)

							set @TotalAmount = 0
						end
					else
						begin
							insert into dbo.FD_Payment_Details([F_Payments], [F_Bills], [C_Sale_Items], [N_Amount])
							select @LINK, [LINK], [C_Sale_Items], dbo.FD_Bills.[N_Amount_Rest]
								from dbo.FD_Bills
							where @UserLink = [F_Subscr] and  year([D_Date]) = year(@dtCounter) and month([D_Date]) = month(@dtCounter)

							update dbo.FD_Bills
								set [N_Amount_Rest] = 0
							where @UserLink = [F_Subscr] and  year([D_Date]) = year(@dtCounter) and month([D_Date]) = month(@dtCounter)

							
							set @TotalAmount = @TotalAmount -@TotalRest
						end
					set @dtCounter = dateadd(month, 1, @dtCounter);
				end
		end
end


/*
	1 ���� �� ������ �������� ��������� ��� ��������� ������ �� � ���������� � ������ ��������� @N_Type
*/
/*
BEGIN TRAN 

    DECLARE @LINK INT 

    INSERT dbo.FD_Payments
    SELECT '�-123', 1, '20190105', 200 

    SET @LINK = SCOPE_IDENTITY()

    EXEC dbo.UI_FP_Payment_Split @LINK = @LINK, @N_Type = 0

    INSERT dbo.FD_Payments
    SELECT '�-124', 1, '20190105', 220 

    SET @LINK = SCOPE_IDENTITY()

    EXEC dbo.UI_FP_Payment_Split @LINK = @LINK, @N_Type = 1

    SELECT * FROM dbo.FD_Bills WHERE F_Subscr = 1
    SELECT * FROM dbo.FD_Payment_Details

ROLLBACK
*/

/*
	2 ���� �� ������ �������� ��������� ��� ��������� ������ �� � ���������� � ������ ��������� @N_Type (�������� �������)
*/
/*
BEGIN TRAN 

    DECLARE @LINK INT 

    INSERT dbo.FD_Payments
    SELECT '�-123', 1, '20190105', 200 

    SET @LINK = SCOPE_IDENTITY()

    EXEC dbo.UI_FP_Payment_Split @LINK = @LINK, @N_Type = 1

    INSERT dbo.FD_Payments
    SELECT '�-124', 1, '20190105', 220 

    SET @LINK = SCOPE_IDENTITY()

    EXEC dbo.UI_FP_Payment_Split @LINK = @LINK, @N_Type = 0

    SELECT * FROM dbo.FD_Bills WHERE F_Subscr = 1
    SELECT * FROM dbo.FD_Payment_Details

ROLLBACK
*/


/*
	3 ���� �� ������ �������� ��������� ��� ������� �������
*/
/*
BEGIN TRAN 

	DECLARE @LINK INT 

	INSERT dbo.FD_Payments
	SELECT '�-123', 1, '20190105', 999999 

	SET @LINK = SCOPE_IDENTITY()

	EXEC dbo.UI_FP_Payment_Split @LINK = @LINK, @N_Type = 1

	SELECT * FROM dbo.FD_Bills WHERE F_Subscr = 1
	SELECT * FROM dbo.FD_Payment_Details

ROLLBACK
*/