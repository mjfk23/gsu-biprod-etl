TRUNCATE TABLE LMS_RUBRIC_PROGRAM;
INSERT INTO LMS_RUBRIC_PROGRAM
  (
    OrgUnitId,
    Type,
    Name,
    Code,
    StartDate,
    EndDate,
    IsActive,
    CreatedDate
  )
SELECT
    ProgramDeptOU.OrgUnitId,
    ProgramDeptOU.Type,
    ProgramDeptOU.Name,
    ProgramDeptOU.Code,
    ProgramDeptOU.StartDate,
    ProgramDeptOU.EndDate,
    ProgramDeptOU.IsActive,
    ProgramDeptOU.CreatedDate
FROM
  D2L_ORGANIZATIONAL_UNIT ProgramDeptOU
WHERE
  ProgramDeptOU.Type IN ('Program','Department') AND
  ProgramDeptOU.IsDeleted = 0 AND
  ProgramDeptOU.IsActive = 1 AND
  EXISTS (
    SELECT
      1
    FROM
      D2L_RUBRIC_OBJECT RubricObject
    WHERE
      RubricObject.OrgUnitID = ProgramDeptOU.OrgUnitId
  )
;

COMMIT;

QUIT;
