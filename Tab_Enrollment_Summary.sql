/* This is the master query used for the Tableau Student Enrollment Dashboard

 */
 
SELECT a.term_desc AS Term,
       a.student_id AS StudentID,
       e.term_start_date,
       a.term_id,
       a.level_id,
       a.level_desc,
       CASE WHEN (a.entry_action_status = 'RS' OR a.student_type_desc = 'High School') THEN a.student_type_desc
            WHEN a.entry_action_status IN ('FF','FH') AND a.student_type_desc = 'Transfer' THEN 'Transfer'
            WHEN a.entry_action_status IN ('FF','FH','TU') AND a.student_type_desc = 'Readmit' THEN 'Readmit'
            WHEN a.entry_action_status IS NULL THEN a.student_type_desc
            ELSE a.entry_action_status
            END AS entry_action_status,
       a.student_type_desc,
       a.primary_level_class_desc,
       b.first_name,
       b.last_name,
       b.birth_date,
       b.gender_code,
       CASE
                 -- International students
                 WHEN b.is_international = TRUE THEN 'International student'
                 WHEN b.us_citizenship_code = '2' THEN 'Non-resident alien'
                 -- IPEDS says Hispanic trumps other race/ethnicity.
                 WHEN b.is_hispanic_latino_ethnicity = TRUE THEN 'Hispanic'
                 -- No particular order.
                 WHEN b.is_multi_racial = TRUE THEN 'Multiracial'
                 WHEN b.is_hawaiian_pacific_islander = TRUE THEN 'Hawaiian/Pacific Islander'
                 WHEN b.is_black = TRUE THEN 'Black/African American'
                 WHEN b.is_american_indian_alaskan = TRUE THEN 'American Indian/Alaskan'
                 WHEN b.is_asian = TRUE THEN 'Asian'
                 WHEN b.is_white = TRUE THEN 'White'
                 ELSE 'Unspecified'
                 END AS Ethnicity,
         b.is_first_generation AS FirstGen,
       a.residency_code,
       a.residency_code_desc,
       b.first_admit_country_desc,
       b.first_admit_state_code,
       b.first_admit_county_desc,
       a.institutional_cumulative_gpa,
       b.latest_high_school_gpa,
       a.transfer_cumulative_gpa,
       a.athlete_activity_desc,
       a.is_athlete,
       b.is_veteran,
       a.student_time_code,
       a.transfer_earned_credits,
       a.institutional_cumulative_credits_earned,
       CASE a.primary_major_college_desc
              WHEN 'Mathematics' THEN 'Coll of Sci, Engr & Tech'
              WHEN '* Natural Sciences' THEN 'Coll of Sci, Engr & Tech'
              WHEN '*Education/Family Studies/PE' THEN 'College of Education'
              WHEN 'Humanities & Social Sciences' THEN 'Coll of Humanities/Soc Sci'
              WHEN 'History/Political Science' THEN 'Coll of Humanities/Soc Sci'
              WHEN 'Computer Information Tech' THEN 'Coll of Sci, Engr & Tech'
              WHEN 'Technologies' THEN 'Coll of Sci, Engr & Tech'
              WHEN 'Nursing' THEN 'College of Health Sciences'
              ELSE a.primary_major_college_desc
              END AS primary_major_college_desc,
       CASE a.primary_major_college_id
                          WHEN 'NS' THEN 'SC' -- Natural Sci into Sci, Engr, & Tech
                          WHEN 'CT' THEN 'SC' -- Computer Info Tech into Sci, Engr, & Tech
                          WHEN 'EF' THEN 'ED' -- Ed/Fam Sci/PE into College of Ed
                          WHEN 'HI' THEN 'HS' -- Hist/Poli Sci into College of Humanities
                          WHEN 'MA' THEN 'SC' -- Math into Sci, Engr, & Tech
                          WHEN 'TE' THEN 'SC' -- Technologies into Sci, Engr, & Tech
                          ELSE primary_major_college_desc
                          END AS college_id1,
       a.primary_major_desc,
       CASE a.secondary_major_college_desc
              WHEN 'Mathematics' THEN 'Coll of Sci, Engr & Tech'
              WHEN '* Natural Sciences' THEN 'Coll of Sci, Engr & Tech'
              WHEN '*Education/Family Studies/PE' THEN 'College of Education'
              WHEN 'Humanities & Social Sciences' THEN 'Coll of Humanities/Soc Sci'
              WHEN 'History/Political Science' THEN 'Coll of Humanities/Soc Sci'
              WHEN 'Computer Information Tech' THEN 'Coll of Sci, Engr & Tech'
              WHEN 'Technologies' THEN 'Coll of Sci, Engr & Tech'
              WHEN 'Nursing' THEN 'College of Health Sciences'
              ELSE a.secondary_major_college_desc
              END AS secondary_major_college_desc,
       CASE a.secondary_major_college_id
                          WHEN 'NS' THEN 'SC' -- Natural Sci into Sci, Engr, & Tech
                          WHEN 'CT' THEN 'SC' -- Computer Info Tech into Sci, Engr, & Tech
                          WHEN 'EF' THEN 'ED' -- Ed/Fam Sci/PE into College of Ed
                          WHEN 'HI' THEN 'HS' -- Hist/Poli Sci into College of Humanities
                          WHEN 'MA' THEN 'SC' -- Math into Sci, Engr, & Tech
                          WHEN 'TE' THEN 'SC' -- Technologies into Sci, Engr, & Tech
                          ELSE secondary_major_college_id
                          END AS college_id2,
             a.secondary_major_desc
      FROM export.student_term_level a
LEFT JOIN export.student b
       ON a.student_id = b.student_id
LEFT JOIN export.term e
       ON a.term_id = e.term_id
         WHERE a.term_id BETWEEN '201540' AND '202240'
           AND a.is_enrolled  IS TRUE
           AND is_primary_level  IS TRUE