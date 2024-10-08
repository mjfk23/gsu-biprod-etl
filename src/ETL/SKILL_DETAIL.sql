TRUNCATE TABLE SKILL_DETAIL;

INSERT INTO SKILL_DETAIL
  (
    SKILL_DETAIL_OWNER_ID,
    SKILL_DETAIL_ID,
    SKILL_DETAIL_DESCRIPTION,
    SKILL_DETAIL_PARENT_ID,
    SKILL_DETAIL_ORGUNIT_ID,
    SKILL_DETAIL_ORGUNIT_TYPE,
    SKILL_DETAIL_ORGUNIT_CODE,
    SKILL_DETAIL_ORGUNIT_NAME,
    SKILL_DETAIL_PROGRAM_ID,
    SKILL_DETAIL_PROGRAM_NAME,
    SKILL_DETAIL_SOURCE
  )
SELECT
  SKILL_OWNER_ID                AS SKILL_DETAIL_OWNER_ID,
  OutcomeDetail.OutcomeId       AS SKILL_DETAIL_ID,
  OutcomeDetail.Description     AS SKILL_DETAIL_DESCRIPTION,
  OutcomeDetail.ParentOutcomeId AS SKILL_DETAIL_PARENT_ID,
  SKILL_OWNER_ORGUNIT_ID        AS SKILL_DETAIL_ORGUNIT_ID,
  SKILL_OWNER_ORGUNIT_TYPE      AS SKILL_DETAIL_ORGUNIT_TYPE,
  SKILL_OWNER_ORGUNIT_CODE      AS SKILL_DETAIL_ORGUNIT_CODE,
  SKILL_OWNER_ORGUNIT_NAME      AS SKILL_OWNER_ORGUNIT_NAME,
  SKILL_OWNER_PROGRAM_ID        AS SKILL_DETAIL_PROGRAM_ID,
  SKILL_OWNER_PROGRAM_NAME      AS SKILL_DETAIL_PROGRAM_NAME,
  CASE
    WHEN SKILL_OWNER_PROGRAM_ID IS NOT NULL THEN 'Program'
    ELSE 'Course'
  END AS SKILL_DETAIL_SOURCE
FROM
  SKILL_OWNER SkillOwner,
  D2L_OUTCOMES_IN_REGISTRY OutcomeRegistry,
  D2L_OUTCOME_DETAIL OutcomeDetail
WHERE
  OutcomeRegistry.RegistryId = SKILL_OWNER_ID AND
  OutcomeDetail.OutcomeId = OutcomeRegistry.OutcomeId
;

MERGE INTO
  SKILL_DETAIL A
USING
  (
    SELECT
      Parent.SKILL_DETAIL_PROGRAM_ID,
      Parent.SKILL_DETAIL_PROGRAM_NAME,
      Child.SKILL_DETAIL_OWNER_ID,
      Child.SKILL_DETAIL_ID
    FROM
      SKILL_DETAIL Parent,
      SKILL_DETAIL Child
    WHERE
      Parent.SKILL_DETAIL_PROGRAM_ID IS NOT NULL AND
      Child.SKILL_DETAIL_ID = Parent.SKILL_DETAIL_ID AND
      Child.SKILL_DETAIL_PROGRAM_ID IS NULL
  ) B
ON
  (
    A.SKILL_DETAIL_OWNER_ID = B.SKILL_DETAIL_OWNER_ID AND
    A.SKILL_DETAIL_ID = B.SKILL_DETAIL_ID
  )
WHEN MATCHED THEN
  UPDATE SET
    A.SKILL_DETAIL_PROGRAM_ID = B.SKILL_DETAIL_PROGRAM_ID,
    A.SKILL_DETAIL_PROGRAM_NAME = B.SKILL_DETAIL_PROGRAM_NAME
;

DECLARE
  record_count NUMBER;
BEGIN
  LOOP
    MERGE INTO
      SKILL_DETAIL A
    USING
      (
        SELECT DISTINCT
          Parent.SKILL_DETAIL_PROGRAM_ID,
          Parent.SKILL_DETAIL_PROGRAM_NAME,
          Child.SKILL_DETAIL_OWNER_ID,
          Child.SKILL_DETAIL_ID
        FROM
          SKILL_DETAIL Parent,
          SKILL_DETAIL Child
        WHERE
          Parent.SKILL_DETAIL_PROGRAM_ID IS NOT NULL AND
          Child.SKILL_DETAIL_PARENT_ID = Parent.SKILL_DETAIL_ID AND
          Child.SKILL_DETAIL_PROGRAM_ID IS NULL
      ) B
    ON
      (
        A.SKILL_DETAIL_OWNER_ID = B.SKILL_DETAIL_OWNER_ID AND
        A.SKILL_DETAIL_ID = B.SKILL_DETAIL_ID
      )
    WHEN MATCHED THEN
      UPDATE SET
        A.SKILL_DETAIL_PROGRAM_ID = B.SKILL_DETAIL_PROGRAM_ID,
        A.SKILL_DETAIL_PROGRAM_NAME = B.SKILL_DETAIL_PROGRAM_NAME
    ;

    SELECT
      COUNT(1)
    INTO
      record_count
    FROM
      SKILL_DETAIL Parent,
      SKILL_DETAIL Child
    WHERE
      Parent.SKILL_DETAIL_PROGRAM_ID IS NOT NULL AND
      Child.SKILL_DETAIL_PARENT_ID = Parent.SKILL_DETAIL_ID AND
      Child.SKILL_DETAIL_PROGRAM_ID IS NULL
    ;

    EXIT WHEN record_count < 1;
  END LOOP;
END;
/

COMMIT;

QUIT;
