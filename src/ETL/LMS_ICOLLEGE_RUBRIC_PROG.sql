TRUNCATE TABLE LMS_ICOLLEGE_RUBRIC_PROG_BREPT;
INSERT INTO LMS_ICOLLEGE_RUBRIC_PROG_BREPT
  (
    PIDM,
    PANTHERID,
    WHKEY,
    META_MAJR,
    META_MAJR_DESC,
    STU_ENROLLED_TERM,
    STU_COLG,
    STU_DEPT,
    STU_DEGR,
    STU_MAJR,
    STU_CONCENT,
    STU_PROG,
    STU_LEVEL,
    STU_TYPE,
    STU_PRIME_CAMP,
    STU_SEX,
    STU_RACE,
    STU_PELL_IND,
    STU_FIRST_GENERATION,
    STU_AGE,
    COLG_DESC,
    DEPT_DESC,
    DEGR_DESC,
    MAJR_DESC,
    CONCENT_DESC,
    STU_LEVEL_DESC,
    STU_TYPE_DESC,
    PRIME_CAMP_DESC,
    STU_LEVEL_REGENTS,
    LEVEL_REGENTS_DESC,
    STU_RACE_DESC,
    STU_ETHNICITY
  )
SELECT
  spriden_pidm AS pidm,
  spriden_id AS pantherid,
  spriden_id AS whkey,
  null AS meta_majr,
  null AS meta_majr_desc,
  sgbstdn_term_code_eff AS stu_enrolled_term,
  sgbstdn_coll_code_1 AS stu_colg,
  sgbstdn_dept_code AS stu_dept,
  sgbstdn_degc_code_1 AS stu_degr,
  sgbstdn_majr_code_1 AS stu_majr,
  sgbstdn_majr_code_conc_1 AS stu_concent,
  sgbstdn_program_1 AS stu_prog,
  sgbstdn_levl_code AS stu_level,
  sgbstdn_styp_code AS stu_type,
  sgbstdn_camp_code AS stu_prime_camp,
  spbpers_sex AS stu_sex,
  gorprac_race_cde AS stu_race,
  null AS stu_pell_ind,
  null AS stu_first_generation,
  FLOOR((SYSDATE - spbpers_birth_date) / 365) AS stu_age,
  (SELECT stvcoll_desc FROM stvcoll@biprod_brept_link_mforest WHERE stvcoll_code = sgbstdn_coll_code_1) AS colg_desc,
  (SELECT stvdept_desc FROM stvdept@biprod_brept_link_mforest WHERE stvdept_code = sgbstdn_dept_code) AS dept_desc,
  (SELECT stvdegc_desc FROM stvdegc@biprod_brept_link_mforest WHERE stvdegc_code = sgbstdn_degc_code_1) AS degr_desc,
  (SELECT stvmajr_desc FROM stvmajr@biprod_brept_link_mforest WHERE stvmajr_code = sgbstdn_majr_code_1) AS majr_desc,
  (SELECT stvmajr_desc FROM stvmajr@biprod_brept_link_mforest WHERE stvmajr_code = sgbstdn_majr_code_conc_1) AS concent_desc,
  (SELECT stvlevl_desc FROM stvlevl@biprod_brept_link_mforest WHERE stvlevl_code = sgbstdn_levl_code) AS stu_level_desc,
  (SELECT stvstyp_desc FROM stvstyp@biprod_brept_link_mforest WHERE stvstyp_code = sgbstdn_styp_code) AS stu_type_desc,
  (SELECT stvcamp_desc FROM stvcamp@biprod_brept_link_mforest WHERE stvcamp_code = sgbstdn_camp_code) AS prime_camp_desc,
  CASE
    WHEN SGBSTDN_LEVL_CODE = 'VT' THEN '05'
    WHEN SGBSTDN_LEVL_CODE IN ('FP','LW','LS','LQ') THEN '80'
    WHEN SGBSTDN_LEVL_CODE = 'GS' AND SGBSTDN_STYP_CODE in ('K','W','ND','TRG','CERM','CERG') THEN '60'
    WHEN SGBSTDN_LEVL_CODE = 'GS' THEN '70'
    WHEN SGBSTDN_LEVL_CODE = 'TRN' THEN '50'
    WHEN SGBSTDN_LEVL_CODE = 'B' THEN '51'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE = 'A' THEN '52'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE IN ('J', 'D') THEN '11'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE IN ('K', 'W') THEN '51'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE < '30' THEN '10'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND (SGBSTDN_STYP_CODE >= '30' AND SGBSTDN_STYP_CODE < '60') THEN '20'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND (SGBSTDN_STYP_CODE >= '60' AND SGBSTDN_STYP_CODE < '90') THEN '30'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE >= '90' THEN '40'
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE = 'X' THEN '50'
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE IN ('J', 'D') THEN '11'
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE IN ('B', 'N') THEN '51'
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE < '30' THEN '10'
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE >= '30' THEN '20'
    ELSE '10'
  END AS stu_level_regents,
  CASE
    WHEN SGBSTDN_LEVL_CODE = 'VT' THEN null
    WHEN SGBSTDN_LEVL_CODE IN ('FP','LW','LS','LQ') THEN null
    WHEN SGBSTDN_LEVL_CODE = 'GS' AND SGBSTDN_STYP_CODE IN ('K','W','ND','TRG','CERM','CERG') THEN 'Non Degree Graduate'
    WHEN SGBSTDN_LEVL_CODE = 'GS' THEN 'Graduate'
    WHEN SGBSTDN_LEVL_CODE = 'TRN' THEN null
    WHEN SGBSTDN_LEVL_CODE = 'B' THEN null
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE = 'A' THEN null
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE IN ('J', 'D') THEN null
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE IN ('K', 'W') THEN null
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE < '30'THEN 'Freshman'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND (SGBSTDN_STYP_CODE >= '30' AND SGBSTDN_STYP_CODE < '60') THEN 'Sophomore'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND (SGBSTDN_STYP_CODE >= '60' AND SGBSTDN_STYP_CODE < '90') THEN 'Junior'
    WHEN SGBSTDN_LEVL_CODE = 'US' AND SGBSTDN_STYP_CODE >= '90' THEN 'Senior'
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE = 'X' THEN null
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE IN ('J', 'D') THEN null
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE IN ('B', 'N') THEN null
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE < '30' THEN 'Freshman'
    WHEN SGBSTDN_LEVL_CODE = 'UA' AND SGBSTDN_STYP_CODE >= '30' THEN 'Sophomore'
    ELSE 'Freshman'
  END AS level_regents_desc,
  gorrace_desc AS stu_race_desc,
  CASE
    WHEN spbpers_ethn_code IS NULL OR spbpers_ethn_code IN ('O', 'N') THEN NULL
    WHEN spbpers_ethn_code IN ('BH','WH','H') THEN 'Hispanic'
    ELSE 'Non-Hispanic'
  END AS stu_ethnicity
FROM
  (
    select
      spriden_pidm,
      spriden_id,
      sgbstdn_term_code_eff,
      sgbstdn_coll_code_1,
      sgbstdn_dept_code,
      sgbstdn_degc_code_1,
      sgbstdn_majr_code_1,
      sgbstdn_majr_code_conc_1,
      sgbstdn_program_1,
      sgbstdn_levl_code,
      sgbstdn_styp_code,
      baninst1.f_primary_campus@biprod_brept_link_mforest(sgbstdn_pidm, sgbstdn_term_code_eff) as sgbstdn_camp_code
    from
      spriden@biprod_brept_link_mforest,
      sgbstdn@biprod_brept_link_mforest
    where
      spriden_change_ind IS NULL AND
      spriden_entity_ind = 'P' AND
      sgbstdn_pidm = spriden_pidm and
      sgbstdn_term_code_eff = (
        SELECT
          MAX(i.sgbstdn_term_code_eff)
        FROM
          sgbstdn@biprod_brept_link_mforest i
        WHERE
          i.sgbstdn_pidm = spriden_pidm AND
          i.sgbstdn_term_code_eff <= (
            select
              min(stvterm_code)
            from
              stvterm@biprod_brept_link_mforest
            where
              stvterm_end_date + 1 > sysdate
          )
      )
  ) sgbstdn,
  spbpers@biprod_brept_link_mforest,
  (
    SELECT
      gorprac_pidm,
      min(gorprac_race_cde) AS gorprac_race_cde,
      min(gorrace_desc) as gorrace_desc
    FROM
      gorprac@biprod_brept_link_mforest,
      gorrace@biprod_brept_link_mforest
    WHERE
      gorrace_race_cde(+) = gorprac_race_cde
    GROUP BY
      gorprac_pidm
    HAVING
      COUNT(DISTINCT gorprac_race_cde) = 1
    UNION
    SELECT
      gorprac_pidm,
      listagg(DISTINCT gorprac_race_cde) WITHIN GROUP(ORDER BY gorprac_race_cde) AS gorprac_race_cde,
      '2 or More Races' as gorrace_desc
    FROM
      gorprac@biprod_brept_link_mforest
    GROUP BY
      gorprac_pidm
    HAVING
      COUNT(DISTINCT gorprac_race_cde) > 1
  ) gorprac
WHERE
  spbpers_pidm(+) = spriden_pidm and
  gorprac_pidm(+) = spriden_pidm
;


TRUNCATE TABLE LMS_ICOLLEGE_RUBRIC_PROG;
INSERT INTO LMS_ICOLLEGE_RUBRIC_PROG
  (
    PIDM,
    BUILD_ORGUNITID,
    BUILD_COURSE_NAME,
    BUILD_COURSE_CODE,
    ORGUNIT_TYPE,
    RUBRICID,
    RUBRIC_NAME,
    ORGUNITID,
    ICOLLEGE_COURSE_NAME,
    ICOLLEGE_COURSE_CODE,
    ASS_BOR_TERM,
    GSU_TERM,
    CRN,
    CRS_XLS_CODE,
    ICOLLEGE_USERNAME,
    ICOLLEGE_FIRSTNAME,
    ICOLLEGE_MIDDLENAME,
    ICOLLEGE_LASTNAME,
    ICOLLEGE_EMAIL,
    ICOLLEGE_USERID,
    RUBRIC_LEVELNAME,
    ASSESSMENTID,
    ASSESSMENTDATE,
    RUBRIC_ACTIVITYTYPE,
    TOTAL_RUBRIC_SCORE,
    RUBRIC_LEVELACHIEVEDID,
    CRITERION_NAME,
    CRITERIONLEVELNAME,
    CRITERIONID,
    CRITERION_SCORE,
    CRITERION_LEVELACHIEVEDID,
    CRITERION_LEVELDESCRIPTION,
    CRITERION_FEEDBACK
  )
SELECT
  UserAccount.SisPIDM as PIDM,
  ProgramDept.OrgUnitId AS BUILD_ORGUNITID,
  ProgramDept.Name AS BUILD_COURSE_NAME,
  ProgramDept.Code AS BUILD_COURSE_CODE,
  ProgramDept.Type AS ORGUNIT_TYPE,
  RubricObject.RubricId AS RUBRICID,
  RubricObject.Name AS RUBRIC_NAME,
  CourseOffering.OrgUnitId AS ORGUNITID,
  CourseOffering.Name AS ICOLLEGE_COURSE_NAME,
  CourseOffering.Code AS ICOLLEGE_COURSE_CODE,
  Semester.Code AS ASS_BOR_TERM,
  CourseOffering.SisTermCode AS GSU_TERM,
  nvl(CourseOffering.SisCrn, (
    SELECT
      min(Section.SisCRN)
    FROM
      D2L_ORGANIZATIONAL_UNIT_ANCESTOR OrgUnitAncestor,
      D2L_USER_ENROLLMENT UserEnrollment,
      D2L_ORGANIZATIONAL_UNIT Section
    WHERE
      OrgUnitAncestor.AncestorOrgUnitId = CourseOffering.OrgUnitId and
      OrgUnitAncestor.OrgUnitType = 'Section' and
      UserEnrollment.OrgUnitId = OrgUnitAncestor.OrgUnitId and
      UserEnrollment.UserId = UserAccount.UserId and
      UserEnrollment.RoleName = 'Student' and
      Section.OrgUnitId = OrgUnitAncestor.OrgUnitId
  )) AS CRN,
  CourseOffering.SisXlsCode AS CRS_XLS_CODE,
  UserAccount.UserName AS ICOLLEGE_USERNAME,
  UserAccount.FirstName AS ICOLLEGE_FIRSTNAME,
  UserAccount.MiddleName AS ICOLLEGE_MIDDLENAME,
  UserAccount.LastName AS ICOLLEGE_LASTNAME,
  UserAccount.ExternalEmail AS ICOLLEGE_EMAIL,
  UserAccount.UserId AS ICOLLEGE_USERID,
  RubricLevel.Name AS RUBRIC_LEVELNAME,
  RubricAssessment.AssessmentId AS ASSESSMENTID,
  RubricAssessment.AssessmentDate AS ASSESSMENTDATE,
  RubricAssessment.ActivityType AS RUBRIC_ACTIVITYTYPE,
  RubricAssessment.Score AS TOTAL_RUBRIC_SCORE,
  RubricAssessment.LevelAchievedId AS RUBRIC_LEVELACHIEVEDID,
  RubricObjectCriteria.Name AS CRITERION_NAME,
  CriteriaLevel.Name AS CRITERIONLEVELNAME,
  RubricAssessmentCriteria.CriterionId AS CRITERIONID,
  RubricAssessmentCriteria.Score AS CRITERION_SCORE,
  RubricAssessmentCriteria.LevelAchievedId AS CRITERION_LEVELACHIEVEDID,
  (
    SELECT
      min(RubricCriteriaLevel.Description)
    FROM
      D2L_RUBRIC_CRITERIA_LEVEL RubricCriteriaLevel
    WHERE
      RubricCriteriaLevel.RubricId = RubricAssessmentCriteria.RubricId AND
      RubricCriteriaLevel.CriterionId = RubricAssessmentCriteria.CriterionId AND
      RubricCriteriaLevel.LevelId = RubricAssessmentCriteria.LevelAchievedId
  ) AS CRITERION_LEVELDESCRIPTION,
  RubricAssessmentCriteria.Feedback AS CRITERION_FEEDBACK
FROM
  (
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
  ) ProgramDept,
  D2L_RUBRIC_OBJECT RubricObject,
  D2L_RUBRIC_ASSESSMENT RubricAssessment,
  D2L_RUBRIC_ASSESSMENT_CRITERIA RubricAssessmentCriteria,
  (
    SELECT
      *
    FROM
      D2L_ORGANIZATIONAL_UNIT CourseOfferingOU
    WHERE
      CourseOfferingOU.IsDeleted = 0 AND
      CourseOfferingOU.Type = 'Course Offering'
  ) CourseOffering,
  D2L_ORGANIZATIONAL_UNIT Semester,
  D2L_USER UserAccount,
  D2L_RUBRIC_OBJECT_LEVELS RubricLevel,
  D2L_RUBRIC_OBJECT_CRITERIA RubricObjectCriteria,
  D2L_RUBRIC_OBJECT_LEVELS CriteriaLevel
WHERE
  -- RubricObject
  RubricObject.OrgUnitId = ProgramDept.OrgUnitId and
  -- RubricAssessment
  RubricAssessment.RubricId = RubricObject.RubricId and
  -- RubricAssessmentCriteria
  RubricAssessmentCriteria.UserId = RubricAssessment.UserId and
  RubricAssessmentCriteria.AssessmentId = RubricAssessment.AssessmentId and
  -- CourseOffering
  CourseOffering.OrgUnitId = RubricAssessment.OrgUnitId and
  -- Semester
  Semester.OrgUnitId = CourseOffering.SemesterId and
  -- UserAccount
  UserAccount.UserId = RubricAssessment.UserId and
  UserAccount.ExternalEmail NOT LIKE 'demo.%@student.gsu.edu' and
  -- RubricLevel
  RubricLevel.LevelId = RubricAssessment.LevelAchievedId and
  -- RubricObjectCriteria
  RubricObjectCriteria.CriterionId = RubricAssessmentCriteria.CriterionId and
  -- CriteriaLevel
  CriteriaLevel.LevelId = RubricAssessmentCriteria.LevelAchievedId
;

MERGE INTO
  LMS_ICOLLEGE_RUBRIC_PROG A
USING
  LMS_ICOLLEGE_RUBRIC_PROG_BREPT B
ON
  (A.PIDM = B.PIDM)
WHEN MATCHED THEN
  UPDATE SET
    A.PANTHERID            = B.PANTHERID,
    A.WHKEY                = B.WHKEY,
    A.STU_ENROLLED_TERM    = B.STU_ENROLLED_TERM,
    A.STU_COLG             = B.STU_COLG,
    A.COLG_DESC            = B.COLG_DESC,
    A.STU_DEPT             = B.STU_DEPT,
    A.DEPT_DESC            = B.DEPT_DESC,
    A.STU_DEGR             = B.STU_DEGR,
    A.DEGR_DESC            = B.DEGR_DESC,
    A.STU_MAJR             = B.STU_MAJR,
    A.MAJR_DESC            = B.MAJR_DESC,
    A.META_MAJR            = B.META_MAJR,
    A.META_MAJR_DESC       = B.META_MAJR_DESC,
    A.STU_CONCENT          = B.STU_CONCENT,
    A.CONCENT_DESC         = B.CONCENT_DESC,
    A.STU_PROG             = B.STU_PROG,
    A.STU_LEVEL_REGENTS    = B.STU_LEVEL_REGENTS,
    A.LEVEL_REGENTS_DESC   = B.LEVEL_REGENTS_DESC,
    A.STU_LEVEL            = B.STU_LEVEL,
    A.STU_LEVEL_DESC       = B.STU_LEVEL_DESC,
    A.STU_TYPE             = B.STU_TYPE,
    A.STU_TYPE_DESC        = B.STU_TYPE_DESC,
    A.STU_PRIME_CAMP       = B.STU_PRIME_CAMP,
    A.PRIME_CAMP_DESC      = B.PRIME_CAMP_DESC,
    A.STU_SEX              = B.STU_SEX,
    A.STU_RACE             = B.STU_RACE,
    A.STU_RACE_DESC        = B.STU_RACE_DESC,
    A.STU_ETHNICITY        = B.STU_ETHNICITY,
    A.STU_AGE              = B.STU_AGE,
    A.STU_PELL_IND         = B.STU_PELL_IND,
    A.STU_FIRST_GENERATION = B.STU_FIRST_GENERATION
  WHERE
    NVL(A.PANTHERID, 0) != NVL(B.PANTHERID, 0) OR
    NVL(A.WHKEY, 0) != NVL(B.WHKEY, 0) OR
    NVL(A.STU_ENROLLED_TERM, 0) != NVL(B.STU_ENROLLED_TERM, 0) OR
    NVL(A.STU_COLG, 0) != NVL(B.STU_COLG, 0) OR
    NVL(A.COLG_DESC, 0) != NVL(B.COLG_DESC, 0) OR
    NVL(A.STU_DEPT, 0) != NVL(B.STU_DEPT, 0) OR
    NVL(A.DEPT_DESC, 0) != NVL(B.DEPT_DESC, 0) OR
    NVL(A.STU_DEGR, 0) != NVL(B.STU_DEGR, 0) OR
    NVL(A.DEGR_DESC, 0) != NVL(B.DEGR_DESC, 0) OR
    NVL(A.STU_MAJR, 0) != NVL(B.STU_MAJR, 0) OR
    NVL(A.MAJR_DESC, 0) != NVL(B.MAJR_DESC, 0) OR
    NVL(A.META_MAJR, 0) != NVL(B.META_MAJR, 0) OR
    NVL(A.META_MAJR_DESC, 0) != NVL(B.META_MAJR_DESC, 0) OR
    NVL(A.STU_CONCENT, 0) != NVL(B.STU_CONCENT, 0) OR
    NVL(A.CONCENT_DESC, 0) != NVL(B.CONCENT_DESC, 0) OR
    NVL(A.STU_PROG, 0) != NVL(B.STU_PROG, 0) OR
    NVL(A.STU_LEVEL_REGENTS, 0) != NVL(B.STU_LEVEL_REGENTS, 0) OR
    NVL(A.LEVEL_REGENTS_DESC, 0) != NVL(B.LEVEL_REGENTS_DESC, 0) OR
    NVL(A.STU_LEVEL, 0) != NVL(B.STU_LEVEL, 0) OR
    NVL(A.STU_LEVEL_DESC, 0) != NVL(B.STU_LEVEL_DESC, 0) OR
    NVL(A.STU_TYPE, 0) != NVL(B.STU_TYPE, 0) OR
    NVL(A.STU_TYPE_DESC, 0) != NVL(B.STU_TYPE_DESC, 0) OR
    NVL(A.STU_PRIME_CAMP, 0) != NVL(B.STU_PRIME_CAMP, 0) OR
    NVL(A.PRIME_CAMP_DESC, 0) != NVL(B.PRIME_CAMP_DESC, 0) OR
    NVL(A.STU_SEX, 0) != NVL(B.STU_SEX, 0) OR
    NVL(A.STU_RACE, 0) != NVL(B.STU_RACE, 0) OR
    NVL(A.STU_RACE_DESC, 0) != NVL(B.STU_RACE_DESC, 0) OR
    NVL(A.STU_ETHNICITY, 0) != NVL(B.STU_ETHNICITY, 0) OR
    NVL(A.STU_AGE, 0) != NVL(B.STU_AGE, 0) OR
    NVL(A.STU_PELL_IND, 0) != NVL(B.STU_PELL_IND, 0) OR
    NVL(A.STU_FIRST_GENERATION, 0) != NVL(B.STU_FIRST_GENERATION, 0)
;

COMMIT;

QUIT;
