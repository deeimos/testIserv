USE MASTER 
GO

IF EXISTS (SELECT 1 FROM sys.databases AS d WHERE d.name = 'DBTestPractice')
DROP DATABASE DBTestPractice 
GO

CREATE DATABASE DBTestPractice;
GO
ALTER DATABASE DBTestPractice
SET RECOVERY SIMPLE;
GO
 
USE DBTestPractice;
GO

IF OBJECT_ID('dbo.DD_Docs') IS NOT NULL DROP TABLE dbo.DD_Docs
GO
IF OBJECT_ID('dbo.SD_Subscrs') IS NOT NULL DROP TABLE dbo.SD_Subscrs
GO
IF OBJECT_ID('dbo.FD_Bills') IS NOT NULL DROP TABLE dbo.FD_Bills
GO
IF OBJECT_ID('dbo.FD_Payments') IS NOT NULL DROP TABLE dbo.FD_Payments
GO
IF OBJECT_ID('dbo.FD_Payment_Details') IS NOT NULL DROP TABLE dbo.FD_Payment_Details
GO

CREATE TABLE dbo.SD_Subscrs -- ������� �����
(
    [LINK]          [int] IDENTITY NOT NULL PRIMARY KEY,    -- ��
    [C_Number]      [varchar](20)  NOT NULL,                -- ����� ��
    [C_FirstName]   [varchar](150) NOT NULL,                -- ���  
    [C_SecondName]  [varchar](150) NOT NULL,                -- �������  
    [C_Address]     [varchar](300) NULL,                    -- ����� �����������
    [C_Doc_Serial]  [varchar](4) NULL,                      -- ����� ��������
    [C_Doc_Number]  [varchar](6) NULL,                      -- ����� �������� 
    [D_BirthDate]   [date] NOT NULL,                        -- ���� ��������    
    CONSTRAINT UC_SD_Subscrs_C_Number UNIQUE(C_Number) 
) 
GO
CREATE TABLE dbo.DD_Docs -- ���������
(
    [LINK]          [int] IDENTITY NOT NULL PRIMARY KEY,    -- ��
    [C_Number]      [varchar] (50) NULL,                    -- �����  
    [F_Subscr]      [int] NOT NULL,                         -- �/�
    [C_Doc_Type]    [varchar](50) NOT NULL,                 -- ��� 
    [D_Date]        [date] NOT NULL DEFAULT GETDATE(),      -- ���� 
    [F_Docs]        [int] NULL,                             -- ������������ ��������
    CONSTRAINT FK_DD_Docs_DD_Docs FOREIGN KEY (F_Docs) REFERENCES dbo.DD_Docs (LINK),
    CONSTRAINT FK_DD_Docs_SD_Subscrs FOREIGN KEY (F_Subscr) REFERENCES dbo.SD_Subscrs (LINK) ON DELETE CASCADE
) 
GO
CREATE TABLE dbo.FD_Bills -- �����
(
    [LINK]          [int] IDENTITY NOT NULL PRIMARY KEY,    -- ��
    [C_Number]      [varchar] (50) NULL,                    -- �����  
    [F_Subscr]      [int] NOT NULL,                         -- �/�
    [C_Sale_Items]  [varchar](50) NOT NULL,                 -- ������
    [D_Date]        [date] NOT NULL DEFAULT GETDATE(),      -- ���� 
    [N_Amount]      [money] NOT NULL,                       -- �����
    [N_Amount_Rest] [money] NOT NULL,                       -- �������
    CONSTRAINT FK_FD_Bills_SD_Subscrs FOREIGN KEY (F_Subscr) REFERENCES dbo.SD_Subscrs (LINK) ON DELETE CASCADE
) 
GO
CREATE TABLE dbo.FD_Payments -- �������
(
    [LINK]          [int] IDENTITY NOT NULL PRIMARY KEY,    -- ��
    [C_Number]      [varchar] (50) NULL,                    -- �����  
    [F_Subscr]      [int] NOT NULL,                         -- �/�
    [D_Date]        [date] NOT NULL DEFAULT GETDATE(),      -- ���� 
    [N_Amount]      [money] NOT NULL,                       -- �����
    CONSTRAINT FK_FD_Payments_SD_Subscrs FOREIGN KEY (F_Subscr) REFERENCES dbo.SD_Subscrs (LINK) ON DELETE CASCADE
) 
GO
CREATE TABLE dbo.FD_Payment_Details -- ����������� ��������
(
    [F_Payments]    [int] NOT NULL,                         -- �� �������
    [F_Bills]       [int] NOT NULL,                         -- �� �����
    [C_Sale_Items]  [varchar](50) NOT NULL,                 -- ������
    [N_Amount]      [money] NOT NULL                        -- �����  
    CONSTRAINT FK_FD_Payment_Details_FD_Payments FOREIGN KEY (F_Payments) REFERENCES dbo.FD_Payments (LINK) ON DELETE CASCADE,
    CONSTRAINT FK_FD_Payment_Details_FD_Bills FOREIGN KEY (F_Bills) REFERENCES dbo.FD_Bills (LINK),
) 
CREATE CLUSTERED INDEX IDC_FD_Payment_Details ON dbo.FD_Payment_Details (F_Payments) 
GO


INSERT dbo.SD_Subscrs
SELECT '10005000', '�������', '������', '�. ���������, ��. ��������, �. 10, ��. 15', '5766', '342456', '19820715'

INSERT dbo.SD_Subscrs
SELECT '10005001', '������', '������', '�. ���������, ��. ��������, �. 1 ��. 88', '4425', '678942', '19850224'

INSERT dbo.SD_Subscrs
SELECT '10005002', '�������', '�������', '�. ���������, ��-��. ������, �. 26 ��. 4', '3435', '567823', '19750904'

INSERT dbo.SD_Subscrs
SELECT '10005003', '�����', '��������', '�. ���������, ��-��. ������, �. 8 ��. 104', '2245', '442567', '20051110'

INSERT dbo.SD_Subscrs
SELECT '10005004', '����', '�������', '�. ���������, ��. 324 ���������� �������, �. 5 ��. 27', '7765', '745832', '20030318'

INSERT dbo.SD_Subscrs
SELECT '10005005', '������', '����������', '�. �������, �. 9', '5535', '665447', '19900601'

SELECT * FROM dbo.SD_Subscrs

INSERT dbo.DD_Docs
SELECT '1-�/1', 1, '��� #1', '20190101', NULL
INSERT dbo.DD_Docs
SELECT '1-�/2', 2, '��� #1', '20190202', NULL
INSERT dbo.DD_Docs
SELECT '1-�/3', 3, '��� #1', '20190115', NULL
INSERT dbo.DD_Docs
SELECT '1-�/4', 4, '��� #1', '20181225', NULL
INSERT dbo.DD_Docs
SELECT '1-�/5', 5, '��� #1', '20181212', NULL
INSERT dbo.DD_Docs
SELECT '2-�/1', 1, '��� #6', '20190104', 1
INSERT dbo.DD_Docs
SELECT '3-�/1', 1, '��� #0', '20190112', 6
INSERT dbo.DD_Docs
SELECT '4-�/1', 1, '��� #4', '20190125', 7
INSERT dbo.DD_Docs
SELECT '5-�/1', 1, '��� #9', '20190202', 8
INSERT dbo.DD_Docs
SELECT '2-�/3', 3, '��� #6', '20190118', 3
INSERT dbo.DD_Docs
SELECT '3-�/3', 3, '��� #0', '20190125', 10
INSERT dbo.DD_Docs
SELECT '6-�/1', 1, '��� #3', '20190105', NULL
INSERT dbo.DD_Docs
SELECT '7-�/1', 1, '��� #3', '20190106', NULL

SELECT * FROM dbo.DD_Docs
 
INSERT dbo.FD_Bills 
SELECT '���-1/1', 1, '���', '20181205', 150, 150  
INSERT dbo.FD_Bills 
SELECT '���-1/1', 1, '���','20181208', 100, 100
INSERT dbo.FD_Bills 
SELECT '���-1/1', 1, '�/�','20181221', 30, 30
INSERT dbo.FD_Bills 
SELECT '���-1/2', 2, '���', '20181211', 170, 170
INSERT dbo.FD_Bills 
SELECT '���-1/2', 2, '���','20181214', 105, 105
INSERT dbo.FD_Bills 
SELECT '���-1/2', 2, '�/�','20181216', 45, 45

INSERT dbo.FD_Bills 
SELECT '���-2/1', 1, '���', '20190105', 165, 165
INSERT dbo.FD_Bills 
SELECT '���-2/1', 1, '���','20190108', 110, 110
INSERT dbo.FD_Bills 
SELECT '���-2/1', 1, '�/�','20190121', 55, 55
INSERT dbo.FD_Bills 
SELECT '���-2/2', 2, '���', '20190111', 185, 185
INSERT dbo.FD_Bills 
SELECT '���-2/2', 2, '���','20190114', 115, 115
INSERT dbo.FD_Bills 
SELECT '���-2/2', 2, '�/�','20190101', 60, 60

INSERT dbo.FD_Bills 
SELECT '���-3/1', 1, '���', '20190205', 165, 165
INSERT dbo.FD_Bills 
SELECT '���-3/1', 1, '���','20190208', 110, 110
INSERT dbo.FD_Bills 
SELECT '���-3/1', 1, '�/�','20190221', 55, 55
INSERT dbo.FD_Bills 
SELECT '���-3/2', 2, '���', '20190211', 185, 185
INSERT dbo.FD_Bills 
SELECT '���-3/2', 2, '���','20190214', 115, 115
INSERT dbo.FD_Bills 
SELECT '���-3/2', 2, '�/�','20190216', 60, 60

SELECT * FROM dbo.FD_Bills

