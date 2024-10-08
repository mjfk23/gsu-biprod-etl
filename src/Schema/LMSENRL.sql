DROP TABLE LMSENRL;

CREATE TABLE LMSENRL (
  LMSENRL_PIDM NUMBER(8,0) DEFAULT NULL,
  LMSENRL_TERM_CODE VARCHAR2(6 CHAR) DEFAULT NULL,
  LMSENRL_CRN VARCHAR2(5 CHAR) DEFAULT NULL,
  LMSENRL_SUBJ_CRSE VARCHAR2(15 CHAR) DEFAULT NULL,
  LMSENRL_XLS_CODE VARCHAR2(15 CHAR) DEFAULT NULL,
  LMSENRL_DEPT_CODE VARCHAR2(4 CHAR) DEFAULT NULL,
  LMSENRL_ENROLLMENT_DATE TIMESTAMP WITH LOCAL TIME ZONE DEFAULT NULL,
  LMSENRL_LAST_ACCESSED TIMESTAMP WITH LOCAL TIME ZONE DEFAULT NULL,
  LMSENRL_COURSE_ID NUMBER(10) DEFAULT NULL,
  LMSENRL_COURSE_CODE NVARCHAR2(100) DEFAULT NULL,
  LMSENRL_COURSE_NAME NVARCHAR2(256) DEFAULT NULL,
  LMSENRL_COURSE_IS_ACTIVE NUMBER(1) DEFAULT NULL,
  LMSENRL_COURSE_IS_DELETED NUMBER(1) DEFAULT NULL,
  LMSENRL_SECTION_ID NUMBER(10) NOT NULL,
  LMSENRL_SECTION_CODE NVARCHAR2(100) DEFAULT NULL,
  LMSENRL_SECTION_NAME NVARCHAR2(256) DEFAULT NULL,
  LMSENRL_SECTION_IS_ACTIVE NUMBER(1) DEFAULT NULL,
  LMSENRL_SECTION_IS_DELETED NUMBER(1) DEFAULT NULL,
  LMSENRL_STUDENT_ID NUMBER(10) NOT NULL,
  LMSENRL_STUDENT_USERNAME NVARCHAR2(540) DEFAULT NULL,
  LMSENRL_STUDENT_FIRST_NAME NVARCHAR2(128) DEFAULT NULL,
  LMSENRL_STUDENT_LAST_NAME NVARCHAR2(128) DEFAULT NULL,
  LMSENRL_STUDENT_AFFILIATIONS VARCHAR2(120 CHAR) DEFAULT NULL,
  LMSENRL_ENROLLEDBY_ID NUMBER(10) DEFAULT NULL,
  LMSENRL_ENROLLEDBY_USERNAME NVARCHAR2(540) DEFAULT NULL,
  LMSENRL_ENROLLEDBY_FIRST_NAME NVARCHAR2(128) DEFAULT NULL,
  LMSENRL_ENROLLEDBY_LAST_NAME NVARCHAR2(128) DEFAULT NULL,
  LMSENRL_ENROLLEDBY_AFFILIATIONS VARCHAR2(120 CHAR) DEFAULT NULL
);

CREATE INDEX IDX_LMSENRL_SECTION_USER ON LMSENRL(LMSENRL_SECTION_ID, LMSENRL_STUDENT_ID);
CREATE INDEX IDX_LMSENRL_PIDM_TERM_CRN ON LMSENRL(LMSENRL_PIDM, LMSENRL_TERM_CODE, LMSENRL_CRN);
CREATE INDEX IDX_LMSENRL_PIDM ON LMSENRL(LMSENRL_PIDM);
CREATE INDEX IDX_LMSENRL_SUBJ_CRSE ON LMSENRL(LMSENRL_SUBJ_CRSE);
CREATE INDEX IDX_LMSENRL_TERM_XLS ON LMSENRL(LMSENRL_TERM_CODE, LMSENRL_XLS_CODE);
CREATE INDEX IDX_LMSENRL_ENROLLMENT_DATE ON LMSENRL(LMSENRL_ENROLLMENT_DATE);
CREATE INDEX IDX_LMSENRL_LAST_ACCESSED ON LMSENRL(LMSENRL_LAST_ACCESSED);
CREATE INDEX IDX_LMSENRL_COURSE_ID ON LMSENRL(LMSENRL_COURSE_ID);
CREATE INDEX IDX_LMSENRL_COURSE_CODE ON LMSENRL(LMSENRL_COURSE_CODE);
CREATE INDEX IDX_LMSENRL_SECTION_ID ON LMSENRL(LMSENRL_SECTION_ID);
CREATE INDEX IDX_LMSENRL_SECTION_CODE ON LMSENRL(LMSENRL_SECTION_CODE);
CREATE INDEX IDX_LMSENRL_STUDENT_ID ON LMSENRL(LMSENRL_STUDENT_ID);
CREATE INDEX IDX_LMSENRL_STUDENT_USERNAME ON LMSENRL(LMSENRL_STUDENT_USERNAME);
CREATE INDEX IDX_LMSENRL_ENROLLEDBY_ID ON LMSENRL(LMSENRL_ENROLLEDBY_ID);
CREATE INDEX IDX_LMSENRL_ENROLLEDBY_USERNAME ON LMSENRL(LMSENRL_ENROLLEDBY_USERNAME);
CREATE BITMAP INDEX IDX_LMSENRL_DEPT_CODE ON LMSENRL(LMSENRL_DEPT_CODE);
CREATE BITMAP INDEX IDX_LMSENRL_TERM_CODE ON LMSENRL(LMSENRL_TERM_CODE);
CREATE BITMAP INDEX IDX_LMSENRL_STUDENT_AFFILIATIONS ON LMSENRL(LMSENRL_STUDENT_AFFILIATIONS);
CREATE BITMAP INDEX IDX_LMSENRL_ENROLLEDBY_AFFILIATIONS ON LMSENRL(LMSENRL_ENROLLEDBY_AFFILIATIONS);

QUIT;
