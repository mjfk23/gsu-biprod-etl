MERGE INTO
  MFOREST.D2L_ORGANIZATIONAL_UNIT_ANCESTOR A
USING
  (
    SELECT
      OrgUnitAncestor.OrgUnitId AS OrgUnitId,
      OrgUnit.Type AS OrgUnitType,
      OrgUnit.Code AS OrgUnitCode,
      OrgUnitAncestor.AncestorOrgUnitId,
      AncestorOrgUnit.Type AS AncestorOrgUnitType,
      AncestorOrgUnit.Code AS AncestorOrgUnitCode
    FROM
      MFOREST.D2L_ORGANIZATIONAL_UNIT_ANCESTOR OrgUnitAncestor,
      MFOREST.D2L_ORGANIZATIONAL_UNIT OrgUnit,
      MFOREST.D2L_ORGANIZATIONAL_UNIT AncestorOrgUnit
    WHERE
      OrgUnit.OrgUnitId = OrgUnitAncestor.OrgUnitId AND
      AncestorOrgUnit.OrgUnitId = OrgUnitAncestor.AncestorOrgUnitId
  ) B
ON
  (
    A.OrgUnitId = B.OrgUnitId AND
    A.AncestorOrgUnitId = B.AncestorOrgUnitId
  )
WHEN MATCHED THEN
  UPDATE SET
    A.OrgUnitType = B.OrgUnitType,
    A.OrgUnitCode = B.OrgUnitCode,
    A.AncestorOrgUnitType = B.AncestorOrgUnitType,
    A.AncestorOrgUnitCode = B.AncestorOrgUnitCode
  WHERE
    NVL(A.OrgUnitType, 0) != NVL(B.OrgUnitType, 0) OR
    NVL(A.OrgUnitCode, 0) != NVL(B.OrgUnitCode, 0) OR
    NVL(A.AncestorOrgUnitType, 0) != NVL(B.AncestorOrgUnitType, 0) OR
    NVL(A.AncestorOrgUnitCode, 0) != NVL(B.AncestorOrgUnitCode, 0)
;


MERGE INTO
  MFOREST.D2L_ORGANIZATIONAL_UNIT_ANCESTOR A
USING
  (
    SELECT
      OrgUnitAncestor.OrgUnitId,
      OrgUnitAncestor.AncestorOrgUnitType,
      CASE WHEN COUNT(1) = 1 THEN 1 END AS OrgUnitSingleAncestor
    FROM
      D2L_ORGANIZATIONAL_UNIT_ANCESTOR OrgUnitAncestor
    GROUP BY
      OrgUnitAncestor.OrgUnitId,
      OrgUnitAncestor.AncestorOrgUnitType
  ) B
ON
  (
    A.OrgUnitId = B.OrgUnitId AND
    A.AncestorOrgUnitType = B.AncestorOrgUnitType
  )
WHEN MATCHED THEN
  UPDATE SET
    A.OrgUnitSingleAncestor = B.OrgUnitSingleAncestor
  WHERE
    NVL(A.OrgUnitSingleAncestor, 0) != NVL(B.OrgUnitSingleAncestor, 0)
;

COMMIT;

QUIT;
