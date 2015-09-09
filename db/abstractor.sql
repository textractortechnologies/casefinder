--duplicate object value?
select count(*), aov.value, aasov.abstractor_abstraction_schema_id
from abstractor_object_values aov join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
group by aov.value, aasov.abstractor_abstraction_schema_id
having count(*) > 1

--duplicate object value variants?
select count(*), aovv.value, aasov.abstractor_abstraction_schema_id
from abstractor_object_values aov join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
                                  join abstractor_object_value_variants aovv on aov.id = aovv.abstractor_object_value_id
group by aovv.value, aasov.abstractor_abstraction_schema_id
having count(*) > 1

--duplicate object value variants within an object value?
select count(*), aovv.value, aasov.abstractor_abstraction_schema_id, aasov.abstractor_object_value_id
from abstractor_object_values aov join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
                                  join abstractor_object_value_variants aovv on aov.id = aovv.abstractor_object_value_id
group by aovv.value, aasov.abstractor_abstraction_schema_id, aasov.abstractor_object_value_id
having count(*) > 1

--all object values and object value variants
select aasov.abstractor_abstraction_schema_id, aov.value, aovv.value
from abstractor_object_values aov join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
                                  join abstractor_object_value_variants aovv on aov.id = aovv.abstractor_object_value_id
--where aov.value = 'gastrinoma, malignant (8153/3)'
order by aasov.abstractor_abstraction_schema_id, aov.value, aovv.value

--List sugestions and sources
select sug.*, source.*
from abstractor_abstractions aa join abstractor_suggestions sug on aa.id = sug.abstractor_abstraction_id
                                join abstractor_suggestion_sources source on sug.id = source.abstractor_suggestion_id
where aa.about_id = 10

--  All flagged cases that were submitted (along with selected histology and site)
SELECT abstractor_subject_groups.*
FROM abstractor_subject_groups
WHERE abstractor_subject_groups.name = 'Primary Cancer'


SELECT pathology_cases.*, pivoted_abstractions.*
FROM pathology_cases LEFT JOIN
                              (SELECT   pathology_cases.id AS subject_id
                                      , MAX(CASE WHEN data.predicate = 'has_cancer_histology' THEN data.value ELSE NULL END) AS has_cancer_histology
                                      , MAX(CASE WHEN data.predicate = 'has_cancer_site' THEN data.value ELSE NULL END) AS has_cancer_site
                               FROM
                                    (SELECT   aas.predicate
                                            , aas.id AS abstraction_schema_id
                                            , asb.subject_type
                                            , aa.about_id
                                            , CASE WHEN aa.value IS NOT NULL AND aa.value != '' THEN aa.value WHEN aa.unknown = true THEN 'unknown' WHEN aa.not_applicable = true THEN 'not applicable' END AS value
                                            , aag.id AS abstractor_abstraction_group_id
                                    FROM abstractor_abstractions aa JOIN abstractor_subjects asb ON aa.abstractor_subject_id = asb.id
                                                                    JOIN abstractor_abstraction_schemas aas ON asb.abstractor_abstraction_schema_id = aas.id
                                                                    JOIN abstractor_abstraction_group_members aagm  ON aa.id = aagm.abstractor_abstraction_id
                                                                    JOIN abstractor_abstraction_groups aag ON aagm.abstractor_abstraction_group_id= aag.id
                                    WHERE asb.subject_type = 'PathologyCase'
                                    AND aag.abstractor_subject_group_id = 1) data join pathology_cases ON  data.about_id = pathology_cases.id
                                    GROUP BY pathology_cases.id, abstractor_abstraction_group_id
                              ) pivoted_abstractions ON pivoted_abstractions.subject_id = pathology_cases.id
WHERE (lower(accession_number) like '%%'
OR EXISTS (SELECT 1 FROM abstractor_abstractions aa JOIN abstractor_subjects sub ON aa.abstractor_subject_id = sub.id AND sub.abstractor_abstraction_schema_id IN (1,2) JOIN abstractor_suggestions sug ON aa.id = sug.abstractor_abstraction_id WHERE aa.deleted_at IS NULL AND aa.about_type = 'PathologyCase' AND pathology_cases.id = aa.about_id AND sug.suggested_value like '%%'))
AND (EXISTS (SELECT 1 FROM abstractor_abstractions aa JOIN abstractor_subjects sub ON aa.abstractor_subject_id = sub.id AND sub.abstractor_abstraction_schema_id IN (1,2) WHERE aa.deleted_at IS NULL AND aa.about_type = 'PathologyCase' AND pathology_cases.id = aa.about_id AND aa.workflow_status = 'submitted' AND aa.workflow_status_whodunnit = COALESCE(NULL, workflow_status_whodunnit)))
AND (EXISTS (SELECT 1 FROM abstractor_abstractions aa JOIN abstractor_subjects sub ON aa.abstractor_subject_id = sub.id AND sub.abstractor_abstraction_schema_id IN (1) JOIN abstractor_suggestions sug ON aa.id = sug.abstractor_abstraction_id JOIN abstractor_suggestion_sources src ON sug.id  = src.abstractor_suggestion_id WHERE aa.deleted_at IS NULL AND aa.about_type = 'PathologyCase' AND pathology_cases.id = aa.about_id AND COALESCE(sug.unknown, 0) = 0 AND sug.suggested_value IS NOT NULL AND COALESCE(sug.suggested_value, '') != '' ))
ORDER BY collection_date asc, pathology_cases.id ASC

--  All flagged cases that were discarded (along with suggested histology and site)

SELECT  pathology_cases.*
FROM pathology_cases
WHERE (lower(accession_number) like '%%'
OR EXISTS (SELECT 1 FROM abstractor_abstractions aa JOIN abstractor_subjects sub ON aa.abstractor_subject_id = sub.id AND sub.abstractor_abstraction_schema_id IN (1,2) JOIN abstractor_suggestions sug ON aa.id = sug.abstractor_abstraction_id WHERE aa.deleted_at IS NULL AND aa.about_type = 'PathologyCase' AND pathology_cases.id = aa.about_id AND sug.suggested_value like '%%'))
AND (EXISTS (SELECT 1 FROM abstractor_abstractions aa JOIN abstractor_subjects sub ON aa.abstractor_subject_id = sub.id AND sub.abstractor_abstraction_schema_id IN (1,2) WHERE aa.deleted_at IS NULL AND aa.about_type = 'PathologyCase' AND pathology_cases.id = aa.about_id AND aa.workflow_status = 'discarded' AND aa.workflow_status_whodunnit = COALESCE(NULL, workflow_status_whodunnit)))
AND (EXISTS (SELECT 1 FROM abstractor_abstractions aa JOIN abstractor_subjects sub ON aa.abstractor_subject_id = sub.id AND sub.abstractor_abstraction_schema_id IN (1) JOIN abstractor_suggestions sug ON aa.id = sug.abstractor_abstraction_id JOIN abstractor_suggestion_sources src ON sug.id  = src.abstractor_suggestion_id WHERE aa.deleted_at IS NULL AND aa.about_type = 'PathologyCase' AND pathology_cases.id = aa.about_id AND COALESCE(sug.unknown, 0) = 0 AND sug.suggested_value IS NOT NULL AND COALESCE(sug.suggested_value, '') != '' ))
ORDER BY collection_date asc, pathology_cases.id ASC


--Fined-grained migration
select count(*)
from abstractor_object_value_variants
where abstractor_object_value_id is null

update abstractor_object_value_variants
set deleted_at = '2015-08-28'
where abstractor_object_value_id is null

select *
from abstractor_object_values aov
where aov.vocabulary_code = '8001/3'
and aov.deleted_at is null

select count(*)
from abstractor_object_values aov
where aov.vocabulary_code like '%/%'
and aov.deleted_at is null
2614

select vocabulary_code, value
from abstractor_object_values aov
where aov.vocabulary_code like '%/%'
and aov.deleted_at is null
order by vocabulary_code, value


select count(*)
from abstractor_object_values aov join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
where aov.deleted_at is null
and aasov.abstractor_abstraction_schema_id = 1


select vocabulary_code, value
from abstractor_object_values aov join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
where aov.deleted_at is null
and aasov.abstractor_abstraction_schema_id = 1
order by aov.vocabulary_code, aov.value

select count(*)
from abstractor_object_values aov join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
where aov.deleted_at is null
and aasov.abstractor_abstraction_schema_id = 1


select count(*)
from abstractor_object_values aov join abstractor_object_value_variants aovv on aov.id = aovv.abstractor_object_value_id
                                  join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
where aov.deleted_at is null
and aasov.abstractor_abstraction_schema_id = 1

select vocabulary_code, aov.value, aovv.value
from abstractor_object_values aov join abstractor_object_value_variants aovv on aov.id = aovv.abstractor_object_value_id
                                  join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
where aov.deleted_at is null
and aasov.abstractor_abstraction_schema_id = 1
order by vocabulary_code, aov.value, aovv.value


select vocabulary_code, value
from abstractor_object_values aov join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
where aov.deleted_at is null
and aasov.abstractor_abstraction_schema_id = 2
order by aov.vocabulary_code, aov.value

select vocabulary_code, aov.value, aovv.value
from abstractor_object_values aov join abstractor_object_value_variants aovv on aov.id = aovv.abstractor_object_value_id
                                  join abstractor_abstraction_schema_object_values aasov on aov.id = aasov.abstractor_object_value_id
where aov.deleted_at is null
and aasov.abstractor_abstraction_schema_id = 2
order by vocabulary_code, aov.value, aovv.value
