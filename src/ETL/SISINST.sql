TRUNCATE TABLE SISINST;

INSERT INTO SISINST
  (
    SISINST_PIDM,
    SISINST_TERM_CODE
  )
SELECT
  SISINST_PIDM,
  MAX(SISINST_TERM_CODE) AS SISINST_TERM_CODE
FROM
  (
    SELECT
      SIBINST_PIDM AS SISINST_PIDM,
      MAX(SIBINST_TERM_CODE_EFF) AS SISINST_TERM_CODE
    FROM
      SIBINST@BIPROD_BREPT_LINK_MFOREST
    GROUP BY
      SIBINST_PIDM
    UNION
    SELECT
      SIRASGN_PIDM AS SISINST_PIDM,
      MAX(SIRASGN_TERM_CODE) AS SISINST_TERM_CODE
    FROM
      SIRASGN@BIPROD_BREPT_LINK_MFOREST
    GROUP BY
      SIRASGN_PIDM
  ) A
WHERE
  SISINST_TERM_CODE >= (
    SELECT
      MIN(STVTERM_CODE) - 400
    FROM
      STVTERM@BIPROD_BREPT_LINK_MFOREST
    WHERE
      STVTERM_END_DATE + 1 >= SYSDATE
  )
GROUP BY
  SISINST_PIDM
;

COMMIT;

QUIT;
