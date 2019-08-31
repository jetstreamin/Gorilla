ALTER FUNCTION dbo.number_compare
(
	@number1 SMALLINT,
	@number2 SMALLINT
)
RETURNS TINYINT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result TINYINT

	-- Add the T-SQL statements to compute the return value here
	SET @result = (CASE WHEN @number1 = @number2 THEN 1 ELSE 0 END)

	-- Return the result of the function
	RETURN @result

END
GO

