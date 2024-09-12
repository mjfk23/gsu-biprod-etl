MERGE INTO
  SKILL_PROGRAM A
USING
  (
    SELECT
      OutcomeProgram.ProgramId as SKILL_PROGRAM_ID,
      OutcomeProgram.ProgramName as SKILL_PROGRAM_NAME,
      OutcomeProgramRegistry.RegistryId as SKILL_PROGRAM_REGISTRY_ID
    FROM
      (
        SELECT
          MIN(OrgUnit.OrgUnitId) as OrgUnitId
        FROM
          D2L_ORGANIZATIONAL_UNIT OrgUnit
        WHERE
          OrgUnit.Type = 'Organization'
        GROUP BY
          OrgUnit.Type
        HAVING
          COUNT(1) = 1
      ) OrgUnit,
      D2L_OUTCOMES_PROGRAM_DETAIL OutcomeProgram,
      (
        SELECT
          OutcomeRegistryOwner.OwnerId AS ProgramId,
          MIN(OutcomeRegistryOwner.RegistryId) AS RegistryId
        FROM
          D2L_OUTCOME_REGISTRY_OWNER OutcomeRegistryOwner
        WHERE
          OutcomeRegistryOwner.OwnerType = 2
        GROUP BY
          OutcomeRegistryOwner.OwnerId
        HAVING
          COUNT(1) = 1
      ) OutcomeProgramRegistry
    WHERE
      OutcomeProgram.OrgUnitId = OrgUnit.OrgUnitId AND
      OutcomeProgramRegistry.ProgramId = OutcomeProgram.ProgramId
  ) B
ON
  (
    A.SKILL_PROGRAM_ID = B.SKILL_PROGRAM_ID
  )
WHEN MATCHED THEN
  UPDATE SET
    A.SKILL_PROGRAM_NAME = B.SKILL_PROGRAM_NAME,
    A.SKILL_PROGRAM_REGISTRY_ID = B.SKILL_PROGRAM_REGISTRY_ID
  WHERE
    A.SKILL_PROGRAM_NAME != B.SKILL_PROGRAM_NAME OR
    A.SKILL_PROGRAM_REGISTRY_ID != B.SKILL_PROGRAM_REGISTRY_ID
WHEN NOT MATCHED THEN
  INSERT
    (
      A.SKILL_PROGRAM_ID,
      A.SKILL_PROGRAM_NAME,
      A.SKILL_PROGRAM_REGISTRY_ID
    )
  VALUES
    (
      B.SKILL_PROGRAM_ID,
      B.SKILL_PROGRAM_NAME,
      B.SKILL_PROGRAM_REGISTRY_ID
    )
;

DELETE FROM
  SKILL_PROGRAM
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      D2L_OUTCOMES_PROGRAM_DETAIL OutcomeProgram
    WHERE
      OutcomeProgram.ProgramId = SKILL_PROGRAM_ID
  )
;

COMMIT;

QUIT;
