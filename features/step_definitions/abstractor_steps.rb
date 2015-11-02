Given(/^abstraction schemas are setup$/) do
  Abstractor::Setup.system
  source_type_nlp_suggestion = Abstractor::AbstractorAbstractionSourceType.where(name: 'nlp suggestion').first
  lightweight = true
  CaseFinder::Setup.setup_abstractor_schemas(source_type_nlp_suggestion, lightweight)
end
