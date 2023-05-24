CREATE TABLE EmailQueue(
    id              int             NOT NULL PRIMARY KEY IDENTITY(1,1),
    toRecipients      varchar(250)    NULL,
    ccRecipients   varchar(250)    NULL,
	bccRecipients  varchar(250)    NULL,
    emailSubject   varchar(250)    NOT NULL,
    emailBody      varchar(max)    NULL,
    queueTime       datetime2       NOT NULL,
    sentTime        datetime2       NULL
);