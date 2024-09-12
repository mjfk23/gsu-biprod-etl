MERGE INTO
  D2L_USER A
USING
  (
    SELECT
      UserAccount.UserName as UserName,
      RoleDetails.RoleName as OrgRoleName,
      CASE
        WHEN REGEXP_LIKE(UserAccount.OrgDefinedId, '^0?90\.([0-9]+)$') THEN
          REGEXP_SUBSTR(UserAccount.OrgDefinedId, '^0?90\.([0-9]+)$', 1, 1, 'i', 1)
      END as SourcedId,
      SISUSER_SOURCED_ID as SisSourcedId,
      SISUSER_PIDM as SisPIDM,
      SISUSER_PANTHER_ID as SisPersonId,
      UserEnrollment.CreatedByUserId as CreatedByUserId
    FROM
      D2L_USER UserAccount,
      D2L_ROLE_DETAIL RoleDetails,
      D2L_USER_ENROLLMENT UserEnrollment,
      (
        SELECT
          MIN(OrgUnit.OrgUnitId) as OrgId
        FROM
          D2L_ORGANIZATIONAL_UNIT OrgUnit
        WHERE
          OrgUnit.Type = 'Organization'
      ) Organization,
      SISUSER
    WHERE
      RoleDetails.RoleId = UserAccount.OrgRoleId AND
      SISUSER_CAMPUS_ID(+) = UserAccount.UserName AND
      UserEnrollment.OrgUnitId(+) = Organization.OrgId AND
      UserEnrollment.UserId(+) = UserAccount.UserId
  ) B
ON
  (
    A.UserName = B.UserName
  )
WHEN MATCHED THEN
  UPDATE SET
    A.OrgRoleName = B.OrgRoleName,
    A.SourcedId = B.SourcedId,
    A.SisSourcedId = B.SisSourcedId,
    A.SisPIDM = B.SisPIDM,
    A.SisPersonId = B.SisPersonId,
    A.CreatedByUserId = B.CreatedByUserId
  WHERE
    NVL(A.OrgRoleName, 0) != NVL(B.OrgRoleName, 0) OR
    NVL(A.SourcedId, 0) != NVL(B.SourcedId, 0) OR
    NVL(A.SisSourcedId, 0) != NVL(B.SisSourcedId, 0) OR
    NVL(A.SisPIDM, 0) != NVL(B.SisPIDM, 0) OR
    NVL(A.SisPersonId, 0) != NVL(B.SisPersonId, 0) OR
    NVL(A.CreatedByUserId, 0) != NVL(B.CreatedByUserId, 0)
;

COMMIT;

QUIT;
