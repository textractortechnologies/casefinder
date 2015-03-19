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