-- 1. cohort 
DROP TABLE IF EXISTS temp_cohort;

select subject_id, cohort_start_date 
into temp temp_cohort
from @cohort_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;

-- 2. join table (cohort + person)
DROP TABLE IF EXISTS temp_cohortperson;

select * 
into temp temp_cohortperson
from temp_cohort
left join @cdm_database_schema.person
on temp_cohort.subject_id = @cdm_database_schema.person.person_id;

-- 2-1. subject_id, cohort_start_date, age, gender_concept_id
DROP TABLE IF EXISTS @target_database_schema.@target_person_table;

select person_id, cohort_start_date, gender_concept_id, (date_part('year', cohort_start_date)-year_of_birth) as age
into @target_database_schema.@target_person_table
from temp_cohortperson;

DROP TABLE IF EXISTS temp_cohort;
DROP TABLE IF EXISTS temp_cohortperson;