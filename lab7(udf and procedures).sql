use master
go
drop  database ATM
go 
Create database ATM
go 
use ATM
go

create table [User](
[userId] int primary key,
[name] varchar(20) not null,
[phoneNum] varchar(15) not null,
[city] varchar(20) not null
)
go

create table CardType(
[cardTypeID] int primary key,
[name] varchar(15),
[description] varchar(40) null
)
go
create Table [Card](
cardNum Varchar(20) primary key,
cardTypeID int foreign key references  CardType([cardTypeID]),
PIN varchar(4) not null,
[expireDate] date not null,
balance float not null
)
go


Create table UserCard(
userID int foreign key references [User]([userId]),
cardNum varchar(20) foreign key references [Card](cardNum),
primary key(cardNum)
)
go
create table [Transaction](
transId int primary key,
transDate date not null,
cardNum varchar(20) foreign key references [Card](cardNum),
amount int not null
)


INSERT [dbo].[User] ([userId], [name], [phoneNum], [city]) VALUES (1, N'Ali', N'03036067000', N'Narowal')
GO
INSERT [dbo].[User] ([userId], [name], [phoneNum], [city]) VALUES (2, N'Ahmed', N'03036047000', N'Lahore')
GO
INSERT [dbo].[User] ([userId], [name], [phoneNum], [city]) VALUES (3, N'Aqeel', N'03036063000', N'Karachi')
GO
INSERT [dbo].[User] ([userId], [name], [phoneNum], [city]) VALUES (4, N'Usman', N'03036062000', N'Sialkot')
GO
INSERT [dbo].[User] ([userId], [name], [phoneNum], [city]) VALUES (5, N'Hafeez', N'03036061000', N'Lahore')
GO


INSERT [dbo].[CardType] ([cardTypeID], [name], [description]) VALUES (1, N'Debit', N'Spend Now, Pay Now')
GO
INSERT [dbo].[CardType] ([cardTypeID], [name], [description]) VALUES (2, N'Credit', N'Spend Now, Pay later')
GO

INSERT [dbo].[Card] ([cardNum], [cardTypeID], [PIN], [expireDate], [balance]) VALUES (N'1234', 1, N'1770', CAST(N'2022-07-01' AS Date), 43025.31)
GO
INSERT [dbo].[Card] ([cardNum], [cardTypeID], [PIN], [expireDate], [balance]) VALUES (N'1235', 1, N'9234', CAST(N'2020-03-02' AS Date), 14425.62)
GO
INSERT [dbo].[Card] ([cardNum], [cardTypeID], [PIN], [expireDate], [balance]) VALUES (N'1236', 1, N'1234', CAST(N'2019-02-06' AS Date), 34325.52)
GO
INSERT [dbo].[Card] ([cardNum], [cardTypeID], [PIN], [expireDate], [balance]) VALUES (N'1237', 2, N'1200', CAST(N'2021-02-05' AS Date), 24325.3)
GO
INSERT [dbo].[Card] ([cardNum], [cardTypeID], [PIN], [expireDate], [balance]) VALUES (N'1238', 2, N'9004', CAST(N'2020-09-02' AS Date), 34025.12)
GO

INSERT [dbo].[UserCard] ([userID], [cardNum]) VALUES (1, N'1234')
GO
INSERT [dbo].[UserCard] ([userID], [cardNum]) VALUES (1, N'1235')
GO
INSERT [dbo].[UserCard] ([userID], [cardNum]) VALUES (2, N'1236')
GO
INSERT [dbo].[UserCard] ([userID], [cardNum]) VALUES (3, N'1238')
GO
Insert  [dbo].[UserCard] ([userID], [cardNum]) VALUES (4, N'1237')

INSERT [dbo].[Transaction] ([transId], [transDate], [cardNum], [amount]) VALUES (1, CAST(N'2017-02-02' AS Date), N'1234', 500)
GO
INSERT [dbo].[Transaction] ([transId], [transDate], [cardNum], [amount]) VALUES (2, CAST(N'2018-02-03' AS Date), N'1235', 3000)
GO
INSERT [dbo].[Transaction] ([transId], [transDate], [cardNum], [amount]) VALUES (3, CAST(N'2020-01-06' AS Date), N'1236', 2500)
GO
INSERT [dbo].[Transaction] ([transId], [transDate], [cardNum], [amount]) VALUES (4, CAST(N'2016-09-09' AS Date), N'1238', 2000)
GO
INSERT [dbo].[Transaction] ([transId], [transDate], [cardNum], [amount]) VALUES (5, CAST(N'2020-02-10' AS Date), N'1234', 6000)
GO


Select * from [User]
Select * from UserCard
Select * from [Card]
Select * from CardType
Select * from [Transaction]
----------------------------------1-------------------------
CREATE FUNCTION balance(@cardNum int)
RETURNS int
AS
BEGIN
declare @balance1 int
select @balance1 = balance  from [Card]
   where [Card].cardNum=@cardNum
return @balance1
end
select  dbo.balance(1235)

-------------------------2----------------------
--Create a UDF that takes userId returns all details of the user.
CREATE FUNCTION dbo.detail(@userid int)
RETURNS TABLE
AS
RETURN SELECT*
from [User] where [User].userId=@userid

Select * from dbo.detail(1)

--------------------3---------------------------------------------
--Create a procedure that takes a user name and display his details.
CREATE procedure detail2 @username varchar(40)
AS
begin SELECT*
from [User] where [User].name=@username
end
execute detail2 @username='Ali'

--------------------4-----------------------
--Create a procedure that takes the userId and displays the owner’s cardNum, balance.Use UDF
--created in question#2 to get the balance against the cardNum.
go
CREATE PROCEDURE display @userid int
as
begin
select  [Card].cardNum ,balance from UserCard
join [Card] on [Card].cardNum=UserCard.cardNum
where [userId] =@userid
end
select dbo.detail(@userid)
go
execute display @userid=2
-------------------------------------5---------

CREATE FUNCTION dbo.display2(@userid int)
RETURNS TABLE
AS
RETURN select  [Card].cardNum ,balance from UserCard
join [Card] on [Card].cardNum=UserCard.cardNum
where [userId] =@userid

select *from dbo.display2(3)

-------------------------------------6-----------
 --Create a procedure that takes the user’s id, and returns no. of cards of that user in an output
--parameter.
 go
 
alter PROCEDURE q6 @userid int
as
begin
select count([Card].cardNum)as noOfCards from [Card]
join UserCard on [Card].cardNum=UserCard.cardNum
where userId=@userid
end
execute q6 @userid=2
------------------------------------------------
-----------------------7------------------------
------------------------------------------------
alter procedure login @cardNum int,@pin int, @status int output
as 
begin
if exists(select * from [card] where [Card].cardNum=@cardNum and [card].pin=@pin)
set @status=1
else
set @status=0
print @status
end
declare @status1 int
execute login @cardnum=1238,@pin=9004,@status=@status1

---------------------------8-----------------------
create procedure updatepin @cardnum int,@oldpin int ,@validpin int 
as
begin 
update [Card]
set [Card].PIN=@validpin
where ([Card].cardNum=@cardnum and [Card].PIN=@oldpin)
if(len(@validpin)=4)
print 'its valid and updated'
else
print 'Error! its invalid'
end
execute  updatepin @cardnum=1238,@oldpin=9004,@validpin=8776
----------------------9--------------------------------------------
CREATE PROCEDURE WithDraw @CardNum INT, @pin INT,@amount INT
AS
BEGIN
DECLARE @statuss INT;
EXECUTE [check_User_exist] @CardNum ,@pin , @status=@statuss OUTPUT;
if (@statuss = 1)
BEGIN
IF EXISTS (SELECT * FROM [Card] WHERE cardNum=@CardNum AND balance > @amount)
BEGIN
DECLARE @maxid INT;
SET @maxid = (SELECT MAX(transId) FROM [Transaction]) + 1;
INSERT INTO [Transaction] VALUES(@maxid,GETDATE(),@CardNum, @amount);
UPDATE [Card]
SET balance = balance - @amount
WHERE cardNum = @CardNum;
PRINT 'Transaction SUCCESSFULL'
END
ELSE
BEGIN
PRINT 'Balance is not enough';
END
END
ELSE
BEGIN
PRINT 'LOGIN FAILED'
END
END;

DECLARE @cardnumm INT;
SET @cardnumm = 1234;
DECLARE @pinn INT;
SET @pinn = 1771;
DECLARE @amountofT INT;
SET @amountofT = 5000;

EXECUTE WithDraw @cardnumm ,@pinn ,@amountofT;
SELECT * FROM [Transaction];
SELECT * FROM [Card];










