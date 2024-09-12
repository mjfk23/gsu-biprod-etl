TRUNCATE TABLE SKILL_DETAIL;

INSERT INTO SKILL_DETAIL
  (
    SKILL_DETAIL_PROGRAM_ID,
    SKILL_DETAIL_PROGRAM_NAME,
    SKILL_DETAIL_REGISTRY_ID,
    SKILL_DETAIL_ID,
    SKILL_DETAIL_DESCRIPTION,
    SKILL_DETAIL_PARENT_ID,
    SKILL_DETAIL_SOURCE
  )
SELECT
  SKILL_PROGRAM_ID AS SKILL_DETAIL_PROGRAM_ID,
  SKILL_PROGRAM_NAME AS SKILL_DETAIL_PROGRAM_NAME,
  SKILL_PROGRAM_REGISTRY_ID AS SKILL_DETAIL_REGISTRY_ID,
  OutcomeDetail.OutcomeId AS SKILL_DETAIL_ID,
  OutcomeDetail.Description AS SKILL_DETAIL_DESCRIPTION,
  OutcomeDetail.ParentOutcomeId AS SKILL_DETAIL_PARENT_ID,
  'Program' AS SKILL_DETAIL_SOURCE
FROM
  SKILL_PROGRAM,
  D2L_OUTCOMES_IN_REGISTRY OutcomeRegistry,
  D2L_OUTCOME_DETAIL OutcomeDetail
WHERE
  OutcomeRegistry.RegistryId = SKILL_PROGRAM_REGISTRY_ID and
  NVL(OutcomeRegistry.IsDeleted, 0) = 0 and
  OutcomeDetail.OutcomeId = OutcomeRegistry.OutcomeId and
  NVL(OutcomeDetail.IsDeleted, 0) = 0
;

DECLARE
  record_count NUMBER;
BEGIN
  LOOP
    INSERT INTO SKILL_DETAIL
      (
        SKILL_DETAIL_PROGRAM_ID,
        SKILL_DETAIL_PROGRAM_NAME,
        SKILL_DETAIL_REGISTRY_ID,
        SKILL_DETAIL_ID,
        SKILL_DETAIL_DESCRIPTION,
        SKILL_DETAIL_PARENT_ID,
        SKILL_DETAIL_SOURCE
      )
    SELECT
      SKILL_DETAIL_PROGRAM_ID AS SKILL_DETAIL_PROGRAM_ID,
      SKILL_DETAIL_PROGRAM_NAME AS SKILL_DETAIL_PROGRAM_NAME,
      OutcomeRegistry.RegistryId AS SKILL_DETAIL_REGISTRY_ID,
      OutcomeDetail.OutcomeId AS SKILL_DETAIL_ID,
      OutcomeDetail.Description AS SKILL_DETAIL_DESCRIPTION,
      OutcomeDetail.ParentOutcomeId AS SKILL_DETAIL_PARENT_ID,
      'Course' AS SKILL_DETAIL_SOURCE
    FROM
      SKILL_DETAIL,
      D2L_OUTCOME_DETAIL OutcomeDetail,
      (
        select
          A.OutcomeId as OutcomeId,
          min(A.RegistryId) as RegistryId
        from
          D2L_OUTCOMES_IN_REGISTRY A
        where
          A.CreatedDate = (
            select
              min(B.CreatedDate)
            from
              D2L_OUTCOMES_IN_REGISTRY B
            where
              B.OutcomeId = A.OutcomeId and
              NVL(B.IsDeleted, 0) = 0
          ) AND
          A.LastModifiedDate = (
            select
              min(B.LastModifiedDate)
            from
              D2L_OUTCOMES_IN_REGISTRY B
            where
              B.OutcomeId = A.OutcomeId AND
              B.CreatedDate = A.CreatedDate and
              NVL(B.IsDeleted, 0) = 0
          ) AND
           NVL(A.IsDeleted, 0) = 0
        group by
          A.OutcomeId
        having
          count(1) = 1
      ) OutcomeRegistry
    WHERE
      OutcomeDetail.ParentOutcomeId = SKILL_DETAIL_PARENT_ID AND
      NVL(OutcomeDetail.IsDeleted, 0) = 0 AND
      not exists (
        select
          1
        from
          SKILL_DETAIL i
        WHERE
          i.SKILL_DETAIL_ID = OutcomeDetail.OutcomeId
      ) and
      OutcomeRegistry.OutcomeId = OutcomeDetail.OutcomeId
    ;

    SELECT
      COUNT(1)
    INTO
      record_count
    FROM
      SKILL_DETAIL,
      D2L_OUTCOME_DETAIL OutcomeDetail,
      (
        select
          A.OutcomeId as OutcomeId,
          min(A.RegistryId) as RegistryId
        from
          D2L_OUTCOMES_IN_REGISTRY A
        where
          A.CreatedDate = (
            select
              min(B.CreatedDate)
            from
              D2L_OUTCOMES_IN_REGISTRY B
            where
              B.OutcomeId = A.OutcomeId and
              NVL(B.IsDeleted, 0) = 0
          ) AND
          A.LastModifiedDate = (
            select
              min(B.LastModifiedDate)
            from
              D2L_OUTCOMES_IN_REGISTRY B
            where
              B.OutcomeId = A.OutcomeId AND
              B.CreatedDate = A.CreatedDate and
              NVL(B.IsDeleted, 0) = 0
          ) AND
          NVL(A.IsDeleted, 0) = 0
        group by
          A.OutcomeId
        having
          count(1) = 1
      ) OutcomeRegistry
    WHERE
      OutcomeDetail.ParentOutcomeId = SKILL_DETAIL_PARENT_ID AND
      NVL(OutcomeDetail.IsDeleted, 0) = 0 AND
      not exists (
        select
          1
        from
          SKILL_DETAIL i
        WHERE
          i.SKILL_DETAIL_ID = OutcomeDetail.OutcomeId
      ) and
      OutcomeRegistry.OutcomeId = OutcomeDetail.OutcomeId
    ;

    EXIT WHEN record_count < 1;
  END LOOP;
END;
/

COMMIT;

QUIT;
