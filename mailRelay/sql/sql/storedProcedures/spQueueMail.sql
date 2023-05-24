-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      John Scott
-- Create Date: 11/23/2022
-- Description: Simple queue mail sproc
-- =============================================
CREATE PROCEDURE sp_queueMail
(
    -- Add the parameters for the stored procedure here
	@toRecipients varchar(250),
	@ccRecipients varchar(250),
	@bccRecipients varchar(250),
	@emailSubject varchar(250),
	@emailBody varchar(max)

)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    INSERT INTO dbo.EmailQueue (toRecipients, ccRecipients, bccRecipients, emailSubject, emailBody, queueTime)
	VALUES (@toRecipients,@ccRecipients,@bccRecipients,@emailSubject,@emailBody,GETUTCDATE())
END
GO
