Abstractor::AbstractorSuggestion.not_deleted.where('unknown = ? and not exists(select 1 from abstractor_suggestion_object_value_variants where abstractor_suggestions.id = abstractor_suggestion_object_value_variants.abstractor_suggestion_id)', 0).each do |abstractor_suggestion|
  if abstractor_suggestion.abstractor_object_value_variants.empty?
    abstractor_suggestion.abstractor_suggestion_sources.each do |abstractor_suggestion_source|
      abstractor_object_value = abstractor_suggestion.abstractor_abstraction.abstractor_subject.abstractor_abstraction_schema.abstractor_object_values.not_deleted.where(value: abstractor_suggestion.suggested_value).first

      if abstractor_object_value && abstractor_suggestion_source.match_value
        abstractor_object_value_variant = abstractor_object_value.abstractor_object_value_variants.not_deleted.where('lower(value) =?', abstractor_suggestion_source.match_value.downcase).first
      end

      if abstractor_object_value_variant && abstractor_suggestion.abstractor_suggestion_object_value_variants.where(abstractor_object_value_variant_id: abstractor_object_value_variant.id).empty?
        abstractor_suggestion.abstractor_suggestion_object_value_variants << Abstractor::AbstractorSuggestionObjectValueVariant.new(abstractor_object_value_variant: abstractor_object_value_variant)
        abstractor_suggestion.save!
      end
    end
  end
end

abstractor_suggestion_source = abstractor_suggestion.abstractor_suggestion_sources.first

abstractor_object_value_variant = abstractor_object_value.abstractor_object_value_variants.not_deleted.where('lower(value) =?', abstractor_suggestion_source.match_value.downcase).first

abstractor_object_value_variant = abstractor_object_value.abstractor_object_value_variants.not_deleted.where('lower(value) =?', 'gastroesophageal junction').first



select sug.id, sug.created_at, suggested_value, source.match_value
from abstractor_suggestions sug join abstractor_suggestion_sources source on sug.id = source.abstractor_suggestion_id
where unknown = 0
and sug.deleted_at is null
and not exists(
select 1
from abstractor_suggestion_object_value_variants asovv
where sug.id = asovv.abstractor_suggestion_id
)


select count(*)
from abstractor_suggestions sug join abstractor_suggestion_sources source on sug.id = source.abstractor_suggestion_id
where unknown = 0
and not exists(
select 1
from abstractor_suggestion_object_value_variants asovv
where sug.id = asovv.abstractor_suggestion_id
)



-- delete from abstractor_suggestion_object_value_variants

