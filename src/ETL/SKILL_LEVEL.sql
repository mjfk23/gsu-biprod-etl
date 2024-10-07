TRUNCATE TABLE SKILL_LEVEL;

INSERT INTO SKILL_LEVEL
  (
    SKILL_LEVEL_ID,
    SKILL_LEVEL_NAME,
    SKILL_LEVEL_PCTSTART,
    SKILL_LEVEL_RGB
  )
SELECT DISTINCT
  OutcomeScaleLevel.ScaleLevelId         AS SKILL_LEVEL_ID,
  OutcomeScaleLevel.Name                 AS SKILL_LEVEL_NAME,
  OutcomeScaleLevel.PercentageRangeStart AS SKILL_LEVEL_PCTSTART,
  OutcomeScaleLevel.RGB                  AS SKILL_LEVEL_RGB
FROM
  D2L_OUTCOMES_SCALE_DEFINITION OutcomeScale,
  D2L_OUTCOMES_SCALE_LEVEL_DEFINITION OutcomeScaleLevel
WHERE
  OutcomeScaleLevel.ScaleId = (
    SELECT
      MIN(OutcomeScaleDefinition.ScaleId) 
    FROM
      D2L_OUTCOMES_SCALE_DEFINITION OutcomeScaleDefinition
    WHERE
      OutcomeScaleDefinition.IsDefault = 1
  )
;

COMMIT;

QUIT;