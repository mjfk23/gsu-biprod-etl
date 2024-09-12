MERGE INTO
  D2L_OUTCOME_DETAIL A
USING
  (
    SELECT
      '5ebec69e-530b-4c59-993c-afef7e4b1d18' AS OutcomeId
    FROM
      dual
  ) B
ON
  (
    A.OutcomeId = B.OutcomeId
  )
WHEN NOT MATCHED THEN
  INSERT
    (
      A.OutcomeId,
      A.OutcomeDefinitionSource,
      A.Description,
      A.CreatedDate,
      A.CreatedBy,
      A.LastModifiedDate,
      A.LastModifiedBy,
      A.IsDeleted
    )
  VALUES
    (
      B.OutcomeId,
      'lores',
      'Career-Ready Competencies (College to Career)',
      SYSDATE,
      0,
      SYSDATE,
      0,
      0
    )
;

MERGE INTO
  D2L_OUTCOMES_IN_REGISTRY A
USING
  (
    SELECT
      '5ebec69e-530b-4c59-993c-afef7e4b1d18' AS OutcomeId,
      'e5d96572-7e7c-4758-b60d-6533ab6b25db' AS RegistryId
    FROM
      dual
  ) B
ON
  (
    A.RegistryId = B.RegistryId AND
    A.OutcomeId = B.OutcomeId
  )
WHEN NOT MATCHED THEN
  INSERT
    (
      A.RegistryId,
      A.OutcomeId,
      A.CreatedDate,
      A.CreatedBy,
      A.LastModifiedDate,
      A.LastModifiedBy,
      A.IsDeleted
    )
  VALUES
    (
      B.RegistryId,
      B.OutcomeId,
      SYSDATE,
      0,
      SYSDATE,
      0,
      0
    )
;

UPDATE
  D2L_OUTCOME_DETAIL
SET
  ParentOutcomeId = '5ebec69e-530b-4c59-993c-afef7e4b1d18' -- 'Career-Ready Competencies (College to Career)'
WHERE
  ParentOutcomeId is null AND
  OutcomeId in (
    '41249f7c-2600-4c33-9891-4748ebebd86e', -- Career Management
    '456799bb-5dd6-4ea0-803c-d056c17dbe2f', -- Critical Thinking
    '5bd55066-8d87-416a-8d69-b4feb4ba8d0a', -- Digital Technology
    'a640356d-fbdc-485f-b8d9-385b259dd9c6', -- Professionalism/Work Ethics
    'ad0d9750-79e6-477f-bdc3-122f7b173e47', -- Oral/Written Communication
    'bb73e84f-8f51-4d76-ba55-7482b84bac92', -- Leadership
    'c439233d-dcce-4427-ad00-fa62c8288585', -- Teamwork/Collaboration
    'e947aad5-e439-43af-889c-80b2fd1e95b7'  -- Global/Intercultural Fluency
  )
;

COMMIT;

QUIT;
