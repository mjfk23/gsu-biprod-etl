MERGE INTO
  D2L_ENROLLMENT_SUMMARY A
USING
  (
    SELECT
      EnrollmentWithdrawalMinMax.UserId,
      EnrollmentWithdrawalMinMax.OrgUnitId,
      OrgUnit.Type as OrgUnitType,
      EnrollmentWithdrawalMinMax.LogIdMin,
      EnrollmentWithdrawalMinMax.LogIdMax,
      EnrollmentWithdrawalMax.Action
    FROM
      (
        SELECT
          EnrollmentWithdrawal.UserId,
          EnrollmentWithdrawal.OrgUnitId,
          MIN(EnrollmentWithdrawal.LogId) AS LogIdMin,
          MAX(EnrollmentWithdrawal.LogId) AS LogIdMax
        FROM
          D2L_ENROLLMENT_AND_WITHDRAWAL EnrollmentWithdrawal
        GROUP BY
          EnrollmentWithdrawal.UserId,
          EnrollmentWithdrawal.OrgUnitId
      ) EnrollmentWithdrawalMinMax,
      D2L_ORGANIZATIONAL_UNIT OrgUnit,
      D2L_ENROLLMENT_AND_WITHDRAWAL EnrollmentWithdrawalMin,
      D2L_ENROLLMENT_AND_WITHDRAWAL EnrollmentWithdrawalMax
    WHERE
      EnrollmentWithdrawalMinMax.LogIdMax > (
        SELECT
          MAX(EnrollmentSummary.LogIdMax)
        FROM
          D2L_ENROLLMENT_SUMMARY EnrollmentSummary
      ) AND
      OrgUnit.OrgUnitId = EnrollmentWithdrawalMinMax.OrgUnitId AND
      EnrollmentWithdrawalMin.LogId = EnrollmentWithdrawalMinMax.LogIdMin AND
      EnrollmentWithdrawalMax.LogId = EnrollmentWithdrawalMinMax.LogIdMax
  ) B
ON
  (
    A.UserId = B.UserId AND
    A.OrgUnitId = B.OrgUnitId
  )
WHEN MATCHED THEN
  UPDATE SET
    A.OrgUnitType = B.OrgUnitType,
    A.LogIdMin = B.LogIdMin,
    A.LogIdMax = B.LogIdMax,
    A.Action = B.Action
  WHERE
    NVL(A.OrgUnitType, 0) != NVL(B.OrgUnitType, 0) OR
    NVL(A.LogIdMin, 0) != NVL(B.LogIdMin, 0) OR
    NVL(A.LogIdMax, 0) != NVL(B.LogIdMax, 0) OR
    NVL(A.Action, 0) != NVL(B.Action, 0)
WHEN NOT MATCHED THEN
  INSERT
    (
      A.UserId,
      A.OrgUnitId,
      A.OrgUnitType,
      A.LogIdMin,
      A.LogIdMax,
      A.Action
    )
  VALUES
    (
      B.UserId,
      B.OrgUnitId,
      B.OrgUnitType,
      B.LogIdMin,
      B.LogIdMax,
      B.Action
    )
;

INSERT INTO D2L_ENROLLMENT_SUMMARY
  (
    UserId,
    OrgUnitId,
    OrgUnitType,
    LogIdMin,
    LogIdMax,
    Action
  )
SELECT
  SectionEnrollment.UserId,
  Section.CourseOfferingId AS OrgUnitId,
  'Course Offering' AS OrgUnitType,
  MIN(SectionEnrollment.LogIdMin) as LogIdMin,
  MIN(SectionEnrollment.LogIdMax) as LogIdMax,
  'Enroll' AS Action
FROM
  D2L_ENROLLMENT_SUMMARY SectionEnrollment,
  D2L_ORGANIZATIONAL_UNIT Section
WHERE
  Section.Type = 'Section' AND
  Section.CourseOfferingId IS NOT NULL AND
  SectionEnrollment.OrgUnitId  = Section.OrgUnitId AND
  SectionEnrollment.Action = 'Enroll' AND
  SectionEnrollment.OrgUnitType = 'Section' AND
  NOT EXISTS (
    SELECT
      1
    FROM
      D2L_ENROLLMENT_SUMMARY CourseOfferingEnrollment
    WHERE
      CourseOfferingEnrollment.UserId = SectionEnrollment.UserId AND
      CourseOfferingEnrollment.OrgUnitId = Section.CourseOfferingId
  )
GROUP BY
  SectionEnrollment.UserId,
  Section.CourseOfferingId
;

DELETE FROM
  D2L_ENROLLMENT_SUMMARY SectionEnrollment
WHERE
  SectionEnrollment.Action = 'Enroll' AND
  SectionEnrollment.OrgUnitType = 'Section' AND
  NOT EXISTS (
    SELECT
      1
    FROM
      D2L_ORGANIZATIONAL_UNIT Section,
      D2L_ENROLLMENT_SUMMARY CourseOfferingEnrollment
    WHERE
      Section.OrgUnitId = SectionEnrollment.OrgUnitId AND
      CourseOfferingEnrollment.UserId = SectionEnrollment.UserId AND
      CourseOfferingEnrollment.OrgUnitId = Section.CourseOfferingId AND
      CourseOfferingEnrollment.Action = 'Enroll'
  )
;

DELETE FROM
  D2L_USER_ENROLLMENT UserEnrollment
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      D2L_ENROLLMENT_SUMMARY EnrollmentSummary
    WHERE
      EnrollmentSummary.UserId = UserEnrollment.UserId AND
      EnrollmentSummary.OrgUnitId = UserEnrollment.OrgUnitId AND
      EnrollmentSummary.Action = 'Enroll'
  )
;

MERGE INTO
  MFOREST.D2L_USER_ENROLLMENT A
USING
  (
    SELECT
      EnrollmentSummary.OrgUnitId,
      EnrollmentSummary.UserId,
      RoleDetail.RoleName,
      EnrollmentWithdrawalMax.EnrollmentDate,
      RoleDetail.RoleId,
      EnrollmentWithdrawalMin.ModifiedByUserId AS CreatedByUserId,
      EnrollmentWithdrawalMax.ModifiedByUserId
    FROM
      D2L_ENROLLMENT_SUMMARY EnrollmentSummary,
      D2L_ENROLLMENT_AND_WITHDRAWAL EnrollmentWithdrawalMin,
      D2L_ENROLLMENT_AND_WITHDRAWAL EnrollmentWithdrawalMax,
      D2L_ROLE_DETAIL RoleDetail
    WHERE
      EnrollmentSummary.Action = 'Enroll' AND
      EnrollmentWithdrawalMin.LogId = EnrollmentSummary.LogIdMin AND
      EnrollmentWithdrawalMax.LogId = EnrollmentSummary.LogIdMax AND
      RoleDetail.RoleId = EnrollmentWithdrawalMax.RoleId
  ) B
ON
  (
    A.UserId = B.UserId AND
    A.OrgUnitId = B.OrgUnitId
  )
WHEN MATCHED THEN
  UPDATE SET
    A.RoleName = B.RoleName,
    A.EnrollmentDate = B.EnrollmentDate,
    A.RoleId = B.RoleId,
    A.CreatedByUserId = B.CreatedByUserId,
    A.ModifiedByUserId = B.ModifiedByUserId
  WHERE
    NVL(A.RoleName, 0) != NVL(B.RoleName, 0) OR
    NVL(A.EnrollmentDate, CURRENT_TIMESTAMP) != NVL(B.EnrollmentDate, CURRENT_TIMESTAMP) OR
    NVL(A.RoleId, 0) != NVL(B.RoleId, 0) OR
    NVL(A.CreatedByUserId, 0) != NVL(B.CreatedByUserId, 0) OR
    NVL(A.ModifiedByUserId, 0) != NVL(B.ModifiedByUserId, 0)
WHEN NOT MATCHED THEN
  INSERT
    (
      A.OrgUnitId,
      A.UserId,
      A.RoleName,
      A.EnrollmentDate,
      A.RoleId,
      A.CreatedByUserId,
      A.ModifiedByUserId
    )
  VALUES
    (
      B.OrgUnitId,
      B.UserId,
      B.RoleName,
      B.EnrollmentDate,
      B.RoleId,
      B.CreatedByUserId,
      B.ModifiedByUserId
    )
;

MERGE INTO
  MFOREST.D2L_USER_ENROLLMENT A
USING
  (
    SELECT
      UserEnrollment.UserId,
      UserEnrollment.OrgUnitId,
      MAX(CourseAccessLog.DayAccessed) as LastAccessed
    FROM
      MFOREST.D2L_USER_ENROLLMENT UserEnrollment,
      MFOREST.D2L_COURSE_ACCESS CourseAccessLog
    WHERE
      CourseAccessLog.UserId = UserEnrollment.UserId AND
      CourseAccessLog.OrgUnitId = UserEnrollment.OrgUnitId AND
      (
        UserEnrollment.LastAccessed is null OR
        CourseAccessLog.DayAccessed > UserEnrollment.LastAccessed
      )
    GROUP BY
      UserEnrollment.UserId,
      UserEnrollment.OrgUnitId
  ) B
ON
  (
    A.UserId = B.UserId AND
    A.OrgUnitId = B.OrgUnitId
  )
WHEN MATCHED THEN
  UPDATE SET
    A.LastAccessed = B.LastAccessed
;

COMMIT;

QUIT;
