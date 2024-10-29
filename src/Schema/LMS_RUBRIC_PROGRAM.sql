DROP TABLE LMS_RUBRIC_PROGRAM;

CREATE TABLE LMS_RUBRIC_PROGRAM (
  OrgUnitId NUMBER(10) NOT NULL,
  Type NVARCHAR2(100) DEFAULT NULL,
  Name NVARCHAR2(256) DEFAULT NULL,
  Code NVARCHAR2(100) DEFAULT NULL,
  StartDate TIMESTAMP WITH LOCAL TIME ZONE DEFAULT NULL,
  EndDate TIMESTAMP WITH LOCAL TIME ZONE DEFAULT NULL,
  IsActive NUMBER(1) DEFAULT NULL,
  CreatedDate TIMESTAMP WITH LOCAL TIME ZONE DEFAULT NULL
);

CREATE UNIQUE INDEX LMS_RUBRIC_PROGRAM_PK ON LMS_RUBRIC_PROGRAM (OrgUnitId);
CREATE INDEX IDX_LMS_RUBRIC_PROGRAM_NAME ON LMS_RUBRIC_PROGRAM(Name);
CREATE INDEX IDX_LMS_RUBRIC_PROGRAM_CODE ON LMS_RUBRIC_PROGRAM(Code);
CREATE INDEX IDX_LMS_RUBRIC_PROGRAM_STARTDATE ON LMS_RUBRIC_PROGRAM(StartDate);
CREATE INDEX IDX_LMS_RUBRIC_PROGRAM_ENDDATE ON LMS_RUBRIC_PROGRAM(EndDate);
CREATE INDEX IDX_LMS_RUBRIC_PROGRAM_CREATEDDATE ON LMS_RUBRIC_PROGRAM(CreatedDate);
CREATE BITMAP INDEX IDX_LMS_RUBRIC_PROGRAM_TYPE ON LMS_RUBRIC_PROGRAM(Type);
CREATE BITMAP INDEX IDX_LMS_RUBRIC_PROGRAM_ISACTIVE ON LMS_RUBRIC_PROGRAM(IsActive);

QUIT;