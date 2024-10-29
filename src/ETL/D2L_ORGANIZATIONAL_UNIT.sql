UPDATE
  D2L_ORGANIZATIONAL_UNIT GroupSection
SET
  GroupSection.Type = 'Section'
WHERE
  GroupSection.Type = 'Group' AND
  GroupSection.Code LIKE 'SEC.090.%'
;
COMMIT;


MERGE INTO
  MFOREST.D2L_ORGANIZATIONAL_UNIT A
USING
  (
    SELECT
      OrgUnit.OrgUnitId,
      CourseOffering.CourseOfferingId,
      CourseTemplate.CourseTemplateId,
      Department.DepartmentId,
      Program.ProgramId,
      College.CollegeId,
      Semester.SemesterId,
      Semester.SisTermCode,
      CASE
        WHEN OrgUnit.Type = 'Section' THEN
          REGEXP_SUBSTR(OrgUnit.Code, '^SEC\.090\.([^\.]*)\.([^\.]+)\.([0-9]+)\.([0-9]{5})$', 1, 1, 'i', 3)
        WHEN OrgUnit.Type = 'Course Offering' THEN
          REGEXP_SUBSTR(OrgUnit.Code, '^CO\.090\.([^\.]*)\.([^\.]+)\.([0-9]+)\.([0-9]{5})$', 1, 1, 'i', 3)
      END AS SisCRN,
      CASE
        WHEN OrgUnit.Type = 'Course Offering' THEN
          REGEXP_SUBSTR(OrgUnit.Code, '^CO\.090\.([^\.]*)\.([^\.]+)\.XLS\.(.*)\.([0-9]{5})$', 1, 1, 'i', 3)
      END AS SisXlsCode,
      CASE
        WHEN OrgUnit.Type = 'Section' THEN
          REGEXP_SUBSTR(OrgUnit.Code, '^SEC\.090\.([^\.]*)\.([^\.]+)\.([0-9]+)\.([0-9]{5})$', 1, 1, 'i', 2)
        WHEN OrgUnit.Type = 'Course Offering' THEN
          REGEXP_SUBSTR(OrgUnit.Code, '^CO\.090\.([^\.]*)\.([^\.]+)\..*\.([0-9]{5})$', 1, 1, 'i', 2)
        WHEN OrgUnit.Type = 'Course Template' THEN
          REGEXP_SUBSTR(OrgUnit.Code, '^090\.([^\.]*)\.([^.]+)$', 1, 1, 'i', 2)
      END AS SisSubjCrse,
      CASE
        WHEN OrgUnit.Type = 'Section' THEN
          REGEXP_SUBSTR(OrgUnit.Code, '^SEC\.090\.([^\.]*)\.([^\.]+)\.([0-9]+)\.([0-9]{5})$', 1, 1, 'i', 1)
        WHEN OrgUnit.Type = 'Course Offering' THEN
          REGEXP_SUBSTR(OrgUnit.Code, '^CO\.090\.([^\.]*)\.([^\.]+)\..*\.([0-9]{5})$', 1, 1, 'i', 1)
        WHEN OrgUnit.Type = 'Course Template' THEN
          REGEXP_SUBSTR(OrgUnit.Code, '^090\.([^\.]*)\.([^.]+)$', 1, 1, 'i', 1)
      END AS SisDeptCode
    FROM
      MFOREST.D2L_ORGANIZATIONAL_UNIT OrgUnit,
      (
        SELECT
          OrgUnitAncestor.OrgUnitId,
          OrgUnitAncestor.AncestorOrgUnitId AS CourseOfferingId
        FROM
          MFOREST.D2L_ORGANIZATIONAL_UNIT_ANCESTOR OrgUnitAncestor
        WHERE
          OrgUnitAncestor.AncestorOrgUnitType = 'Course Offering' AND
          OrgUnitAncestor.OrgUnitSingleAncestor = 1
      ) CourseOffering,
      (
        SELECT
          OrgUnitAncestor.OrgUnitId,
          OrgUnitAncestor.AncestorOrgUnitId AS CourseTemplateId
        FROM
          MFOREST.D2L_ORGANIZATIONAL_UNIT_ANCESTOR OrgUnitAncestor
        WHERE
          OrgUnitAncestor.AncestorOrgUnitType = 'Course Template' AND
          OrgUnitAncestor.OrgUnitSingleAncestor = 1
      ) CourseTemplate,
      (
        SELECT
          OrgUnitAncestor.OrgUnitId,
          OrgUnitAncestor.AncestorOrgUnitId AS DepartmentId
        FROM
          MFOREST.D2L_ORGANIZATIONAL_UNIT_ANCESTOR OrgUnitAncestor
        WHERE
          OrgUnitAncestor.AncestorOrgUnitType = 'Department' AND
          OrgUnitAncestor.OrgUnitSingleAncestor = 1
      ) Department,
      (
        SELECT
          OrgUnitAncestor.OrgUnitId,
          OrgUnitAncestor.AncestorOrgUnitId AS ProgramId
        FROM
          MFOREST.D2L_ORGANIZATIONAL_UNIT_ANCESTOR OrgUnitAncestor
        WHERE
          OrgUnitAncestor.AncestorOrgUnitType = 'Program' AND
          OrgUnitAncestor.OrgUnitSingleAncestor = 1
      ) Program,
      (
        SELECT
          OrgUnitAncestor.OrgUnitId,
          OrgUnitAncestor.AncestorOrgUnitId AS CollegeId
        FROM
          MFOREST.D2L_ORGANIZATIONAL_UNIT_ANCESTOR OrgUnitAncestor
        WHERE
          OrgUnitAncestor.AncestorOrgUnitType = 'College' AND
          OrgUnitAncestor.OrgUnitSingleAncestor = 1
      ) College,
      (
        select
          OrgUnitAncestor.OrgUnitId,
          OrgUnitAncestor.AncestorOrgUnitId as SemesterId,
          case
            WHEN NOT REGEXP_LIKE(OrgUnit.Code, '^[0-9]{4}[124]$') THEN NULL
            WHEN SUBSTR(OrgUnit.Code, -1, 1) = 1 THEN (TO_NUMBER(SUBSTR(OrgUnit.Code, 0, 4)) - 1) || N'05'
            WHEN SUBSTR(OrgUnit.Code, -1, 1) = 2 THEN (TO_NUMBER(SUBSTR(OrgUnit.Code, 0, 4)) - 1) || N'08'
            WHEN SUBSTR(OrgUnit.Code, -1, 1) = 4 THEN SUBSTR(OrgUnit.Code, 0, 4) || N'01'
          END AS SisTermCode
        FROM
          MFOREST.D2L_ORGANIZATIONAL_UNIT_ANCESTOR OrgUnitAncestor,
          MFOREST.D2L_ORGANIZATIONAL_UNIT OrgUnit
        WHERE
          OrgUnitAncestor.AncestorOrgUnitType = 'Semester' AND
          OrgUnitAncestor.OrgUnitSingleAncestor = 1 AND
          OrgUnit.OrgUnitId = OrgUnitAncestor.AncestorOrgUnitId AND
          OrgUnit.Type = 'Semester'
      ) Semester
    WHERE
      CourseOffering.OrgUnitId(+) = OrgUnit.OrgUnitId AND
      CourseTemplate.OrgUnitId(+) = OrgUnit.OrgUnitId AND
      Department.OrgUnitId(+) = OrgUnit.OrgUnitId AND
      Program.OrgUnitId(+) = OrgUnit.OrgUnitId AND
      College.OrgUnitId(+) = OrgUnit.OrgUnitId AND
      Semester.OrgUnitId(+) = OrgUnit.OrgUnitId
  ) B
ON
  (
    A.OrgUnitId = B.OrgUnitId
  )
WHEN MATCHED THEN
  UPDATE SET
    A.CourseOfferingId = B.CourseOfferingId,
    A.CourseTemplateId = B.CourseTemplateId,
    A.DepartmentId = B.DepartmentId,
    A.ProgramId = B.ProgramId,
    A.CollegeId = B.CollegeId,
    A.SemesterId = B.SemesterId,
    A.SisTermCode = B.SisTermCode,
    A.SisCRN = B.SisCRN,
    A.SisXlsCode = B.SisXlsCode,
    A.SisSubjCrse = B.SisSubjCrse,
    A.SisDeptCode = B.SisDeptCode
  WHERE
    NVL(A.CourseOfferingId, 0) != NVL(B.CourseOfferingId, 0) OR
    NVL(A.CourseTemplateId, 0) != NVL(B.CourseTemplateId, 0) OR
    NVL(A.DepartmentId, 0) != NVL(B.DepartmentId, 0) OR
    NVL(A.ProgramId, 0) != NVL(B.ProgramId, 0) OR
    NVL(A.CollegeId, 0) != NVL(B.CollegeId, 0) OR
    NVL(A.SemesterId, 0) != NVL(B.SemesterId, 0) OR
    NVL(A.SisTermCode, 0) != NVL(B.SisTermCode, 0) OR
    NVL(A.SisCRN, 0) != NVL(B.SisCRN, 0) OR
    NVL(A.SisXlsCode, 0) != NVL(B.SisXlsCode, 0) OR
    NVL(A.SisSubjCrse, 0) != NVL(B.SisSubjCrse, 0) OR
    NVL(A.SisDeptCode, 0) != NVL(B.SisDeptCode, 0)
;

COMMIT;

QUIT;
