MERGE INTO
  SKILL_LEVEL A
USING
  (
    SELECT DISTINCT
      OutcomeScaleLevel.ScaleLevelId as SKILL_LEVEL_ID,
      OutcomeScaleLevel.Name as SKILL_LEVEL_NAME,
      OutcomeScaleLevel.PercentageRangeStart as SKILL_LEVEL_PCTSTART,
      OutcomeScaleLevel.RGB as SKILL_LEVEL_RGB
    FROM
      D2L_OUTCOMES_SCALE_LEVEL_DEFINITION OutcomeScaleLevel
    WHERE
      OutcomeScaleLevel.ScaleId = (
        SELECT
          MIN(OutcomeScaleDefinition.ScaleId) as ScaleId 
        FROM
          D2L_ORGANIZATIONAL_UNIT OrgUnit,
          D2L_OUTCOME_REGISTRY_OWNER OutcomeRegistryOwner,
          D2L_OUTCOMES_SCALE_DEFINITION OutcomeScaleDefinition
        WHERE
          OrgUnit.Type = 'Organization' AND
          OutcomeRegistryOwner.OwnerType = 1 AND
          OutcomeRegistryOwner.OwnerId = OrgUnit.OrgUnitId AND
          OutcomeScaleDefinition.RegistryId = OutcomeRegistryOwner.RegistryId
        GROUP BY
          OrgUnit.Type
        HAVING
          COUNT(1) = 1
      )
  ) B
ON
  (
    A.SKILL_LEVEL_ID = B.SKILL_LEVEL_ID
  )
WHEN MATCHED THEN
  UPDATE SET
    A.SKILL_LEVEL_NAME = B.SKILL_LEVEL_NAME,
    A.SKILL_LEVEL_PCTSTART = B.SKILL_LEVEL_PCTSTART,
    A.SKILL_LEVEL_RGB = B.SKILL_LEVEL_RGB
  WHERE
    A.SKILL_LEVEL_NAME != B.SKILL_LEVEL_NAME OR
    A.SKILL_LEVEL_PCTSTART != B.SKILL_LEVEL_PCTSTART OR
    A.SKILL_LEVEL_RGB != B.SKILL_LEVEL_RGB
WHEN NOT MATCHED THEN
  INSERT
    (
      A.SKILL_LEVEL_ID,
      A.SKILL_LEVEL_NAME,
      A.SKILL_LEVEL_PCTSTART,
      A.SKILL_LEVEL_RGB
    )
  VALUES
    (
      B.SKILL_LEVEL_ID,
      B.SKILL_LEVEL_NAME,
      B.SKILL_LEVEL_PCTSTART,
      B.SKILL_LEVEL_RGB
    )
;

DELETE FROM
  SKILL_LEVEL
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      D2L_OUTCOMES_SCALE_LEVEL_DEFINITION OutcomeScaleLevel
    WHERE
      OutcomeScaleLevel.ScaleLevelId = SKILL_LEVEL_ID
  )
;

COMMIT;

QUIT;