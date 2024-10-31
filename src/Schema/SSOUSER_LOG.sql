DROP TABLE SSOUSER_LOG;
DROP SEQUENCE SSOUSER_LOG_SEQ;

CREATE SEQUENCE SSOUSER_LOG_SEQ;
CREATE TABLE SSOUSER_LOG (
  SSOUSER_LOG_SEQ NUMBER(20) NOT NULL,
  SSOUSER_LOG_TIMESTAMP TIMESTAMP WITH LOCAL TIME ZONE NOT NULL, 
  SSOUSER_LOG_ACTION CHAR(1) NOT NULL,
  SSOUSER_CAMPUS_ID VARCHAR2(30 CHAR) DEFAULT NULL,
  SSOUSER_EMAIL_ADDRESS VARCHAR2(128 CHAR) DEFAULT NULL,
  SSOUSER_FIRST_NAME VARCHAR2(128 CHAR) DEFAULT NULL,
  SSOUSER_LAST_NAME VARCHAR2(128 CHAR) DEFAULT NULL,
  SSOUSER_ACCOUNT_STATUS VARCHAR2(420 CHAR) DEFAULT NULL,
  SSOUSER_ACCOUNT_DISABLED NUMBER(1) DEFAULT NULL,
  SSOUSER_AFFILIATIONS VARCHAR2(120 CHAR) DEFAULT NULL,
  SSOUSER_IS_STUDENT NUMBER(1) DEFAULT NULL,
  SSOUSER_IS_FACULTY NUMBER(1) DEFAULT NULL,
  SSOUSER_IS_STAFF NUMBER(1) DEFAULT NULL,
  SSOUSER_IS_AFFILIATE NUMBER(1) DEFAULT NULL,
  SSOUSER_IS_RETIREE NUMBER(1) DEFAULT NULL,
  SSOUSER_CREATE_DATE TIMESTAMP WITH LOCAL TIME ZONE DEFAULT NULL,
  SSOUSER_UPDATE_DATE TIMESTAMP WITH LOCAL TIME ZONE DEFAULT NULL,
  SSOUSER_PWD_LAST_SET TIMESTAMP WITH LOCAL TIME ZONE DEFAULT NULL
);

CREATE UNIQUE INDEX PUK_SSOUSER_LOG_SEQ ON SSOUSER_LOG (SSOUSER_LOG_SEQ);
CREATE INDEX IDX_SSOUSER_LOG_TIMESTAMP ON SSOUSER_LOG (SSOUSER_LOG_TIMESTAMP);
CREATE INDEX IDX_SSOUSER_LOG_CAMPUS_ID ON SSOUSER_LOG (SSOUSER_CAMPUS_ID);
CREATE INDEX IDX_SSOUSER_LOG_EMAIL_ADDRESS ON SSOUSER_LOG (SSOUSER_EMAIL_ADDRESS);
CREATE INDEX IDX_SSOUSER_LOG_NAME ON SSOUSER_LOG (SSOUSER_LAST_NAME, SSOUSER_FIRST_NAME);
CREATE INDEX IDX_SSOUSER_LOG_ACCOUNT_STATUS ON SSOUSER_LOG (SSOUSER_ACCOUNT_STATUS);
CREATE INDEX IDX_SSOUSER_LOG_AFFILIATIONS ON SSOUSER_LOG (SSOUSER_AFFILIATIONS);
CREATE INDEX IDX_SSOUSER_LOG_CREATE_DATE ON SSOUSER_LOG (SSOUSER_CREATE_DATE);
CREATE INDEX IDX_SSOUSER_LOG_UPDATE_DATE ON SSOUSER_LOG (SSOUSER_UPDATE_DATE);
CREATE INDEX IDX_SSOUSER_LOG_PWD_LAST_SET ON SSOUSER_LOG (SSOUSER_PWD_LAST_SET);
CREATE BITMAP INDEX IDX_SSOUSER_LOG_ACTION ON SSOUSER_LOG (SSOUSER_LOG_ACTION);
CREATE BITMAP INDEX IDX_SSOUSER_LOG_ACCOUNT_DISABLED ON SSOUSER_LOG (SSOUSER_ACCOUNT_DISABLED);
CREATE BITMAP INDEX IDX_SSOUSER_LOG_IS_STUDENT ON SSOUSER_LOG (SSOUSER_IS_STUDENT);
CREATE BITMAP INDEX IDX_SSOUSER_LOG_IS_FACULTY ON SSOUSER_LOG (SSOUSER_IS_FACULTY);
CREATE BITMAP INDEX IDX_SSOUSER_LOG_IS_STAFF ON SSOUSER_LOG (SSOUSER_IS_STAFF);
CREATE BITMAP INDEX IDX_SSOUSER_LOG_IS_AFFILIATE ON SSOUSER_LOG (SSOUSER_IS_AFFILIATE);
CREATE BITMAP INDEX IDX_SSOUSER_LOG_IS_RETIREE ON SSOUSER_LOG (SSOUSER_IS_RETIREE);

QUIT;
