# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170104035056) do

  create_table "abstractor_abstraction_group_members", force: :cascade do |t|
    t.integer  "abstractor_abstraction_group_id", limit: 4
    t.integer  "abstractor_abstraction_id",       limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abstractor_abstraction_group_members", ["abstractor_abstraction_group_id"], name: "index_abstractor_abstraction_group_id", using: :btree
  add_index "abstractor_abstraction_group_members", ["abstractor_abstraction_id"], name: "index_abstractor_abstraction_id", using: :btree

  create_table "abstractor_abstraction_groups", force: :cascade do |t|
    t.integer  "abstractor_subject_group_id", limit: 4
    t.string   "about_type",                  limit: 255
    t.integer  "about_id",                    limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "system_generated",                        default: false
    t.string   "subtype",                     limit: 255
  end

  add_index "abstractor_abstraction_groups", ["about_id", "about_type", "deleted_at"], name: "index_about_id_about_type_deleted_at", using: :btree

  create_table "abstractor_abstraction_object_values", force: :cascade do |t|
    t.integer  "abstractor_abstraction_id",  limit: 4
    t.integer  "abstractor_object_value_id", limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_schema_object_values", force: :cascade do |t|
    t.integer  "abstractor_abstraction_schema_id", limit: 4
    t.integer  "abstractor_object_value_id",       limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "display_order",                    limit: 4
  end

  create_table "abstractor_abstraction_schema_predicate_variants", force: :cascade do |t|
    t.integer  "abstractor_abstraction_schema_id", limit: 4
    t.string   "value",                            limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_schema_relations", force: :cascade do |t|
    t.integer  "subject_id",                  limit: 4
    t.integer  "object_id",                   limit: 4
    t.integer  "abstractor_relation_type_id", limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_schemas", force: :cascade do |t|
    t.string   "predicate",                 limit: 255
    t.string   "display_name",              limit: 255
    t.integer  "abstractor_object_type_id", limit: 4
    t.string   "preferred_name",            limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_source_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_sources", force: :cascade do |t|
    t.integer  "abstractor_subject_id",                 limit: 4
    t.string   "from_method",                           limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "custom_method",                         limit: 255
    t.integer  "abstractor_abstraction_source_type_id", limit: 4
    t.integer  "abstractor_rule_type_id",               limit: 4
    t.string   "section_name",                          limit: 255
    t.string   "custom_nlp_provider",                   limit: 255
  end

  create_table "abstractor_abstractions", force: :cascade do |t|
    t.integer  "abstractor_subject_id",     limit: 4
    t.string   "value",                     limit: 255
    t.string   "about_type",                limit: 255
    t.integer  "about_id",                  limit: 4
    t.boolean  "unknown"
    t.boolean  "not_applicable"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_status",           limit: 255
    t.string   "workflow_status_whodunnit", limit: 255
  end

  add_index "abstractor_abstractions", ["about_id", "about_type", "deleted_at"], name: "index_about_id_about_type_deleted_at_2", using: :btree
  add_index "abstractor_abstractions", ["abstractor_subject_id"], name: "index_abstractor_subject_id", using: :btree

  create_table "abstractor_indirect_sources", force: :cascade do |t|
    t.integer  "abstractor_abstraction_id",        limit: 4
    t.integer  "abstractor_abstraction_source_id", limit: 4
    t.string   "source_type",                      limit: 255
    t.integer  "source_id",                        limit: 4
    t.string   "source_method",                    limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_object_types", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_object_value_variants", force: :cascade do |t|
    t.integer  "abstractor_object_value_id", limit: 4
    t.string   "value",                      limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_object_values", force: :cascade do |t|
    t.string   "value",              limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "properties",         limit: 65535
    t.string   "vocabulary_code",    limit: 255
    t.string   "vocabulary",         limit: 255
    t.string   "vocabulary_version", limit: 255
  end

  create_table "abstractor_relation_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_rule_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_section_name_variants", force: :cascade do |t|
    t.integer  "abstractor_section_id", limit: 4
    t.string   "name",                  limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_section_types", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "regular_expression", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_sections", force: :cascade do |t|
    t.integer  "abstractor_section_type_id",   limit: 4
    t.string   "source_type",                  limit: 255
    t.string   "source_method",                limit: 255
    t.string   "name",                         limit: 255
    t.string   "description",                  limit: 255
    t.string   "delimiter",                    limit: 255
    t.string   "custom_regular_expression",    limit: 255
    t.boolean  "return_note_on_empty_section"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_subject_group_members", force: :cascade do |t|
    t.integer  "abstractor_subject_id",       limit: 4
    t.integer  "abstractor_subject_group_id", limit: 4
    t.integer  "display_order",               limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abstractor_subject_group_members", ["abstractor_subject_id"], name: "index_abstractor_subject_id_2", using: :btree

  create_table "abstractor_subject_groups", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cardinality",            limit: 4
    t.string   "subtype",                limit: 255
    t.boolean  "enable_workflow_status",             default: false
    t.string   "workflow_status_submit", limit: 255
    t.string   "workflow_status_pend",   limit: 255
  end

  create_table "abstractor_subject_relations", force: :cascade do |t|
    t.integer  "subject_id",                  limit: 4
    t.integer  "object_id",                   limit: 4
    t.integer  "abstractor_relation_type_id", limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_subjects", force: :cascade do |t|
    t.integer  "abstractor_abstraction_schema_id", limit: 4
    t.string   "subject_type",                     limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dynamic_list_method",              limit: 255
    t.string   "namespace_type",                   limit: 255
    t.integer  "namespace_id",                     limit: 4
  end

  add_index "abstractor_subjects", ["namespace_type", "namespace_id"], name: "index_namespace_type_namespace_id", using: :btree
  add_index "abstractor_subjects", ["subject_type"], name: "index_subject_type", using: :btree

  create_table "abstractor_suggestion_object_values", force: :cascade do |t|
    t.integer  "abstractor_suggestion_id",   limit: 4
    t.integer  "abstractor_object_value_id", limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_suggestion_sources", force: :cascade do |t|
    t.integer  "abstractor_abstraction_source_id", limit: 4
    t.integer  "abstractor_suggestion_id",         limit: 4
    t.text     "match_value",                      limit: 65535
    t.text     "sentence_match_value",             limit: 65535
    t.integer  "source_id",                        limit: 4
    t.string   "source_method",                    limit: 255
    t.string   "source_type",                      limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "custom_method",                    limit: 255
    t.string   "custom_explanation",               limit: 255
    t.string   "section_name",                     limit: 255
  end

  add_index "abstractor_suggestion_sources", ["abstractor_suggestion_id"], name: "index_abstractor_suggestion_id", using: :btree

  create_table "abstractor_suggestions", force: :cascade do |t|
    t.integer  "abstractor_abstraction_id", limit: 4
    t.string   "suggested_value",           limit: 255
    t.boolean  "unknown"
    t.boolean  "not_applicable"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted"
  end

  add_index "abstractor_suggestions", ["abstractor_abstraction_id"], name: "index_abstractor_abstraction_id_2", using: :btree

  create_table "access_audits", force: :cascade do |t|
    t.string   "username",    limit: 255
    t.string   "action",      limit: 255,   null: false
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "batch_export_details", force: :cascade do |t|
    t.integer  "batch_export_id",                 limit: 4, null: false
    t.integer  "abstractor_abstraction_group_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "batch_exports", force: :cascade do |t|
    t.datetime "exported_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batch_imports", force: :cascade do |t|
    t.datetime "imported_at",                     null: false
    t.string   "import_file",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "import_body",       limit: 65535
    t.integer  "pathology_case_id", limit: 4
    t.text     "status",            limit: 65535
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               limit: 4,     default: 0, null: false
    t.integer  "attempts",               limit: 4,     default: 0, null: false
    t.text     "handler",                limit: 65535,             null: false
    t.text     "last_error",             limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",              limit: 255
    t.string   "queue",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delayed_reference_id",   limit: 4
    t.string   "delayed_reference_type", limit: 255
  end

  add_index "delayed_jobs", ["delayed_reference_id"], name: "delayed_jobs_delayed_reference_id", using: :btree
  add_index "delayed_jobs", ["delayed_reference_type"], name: "delayed_jobs_delayed_reference_type", using: :btree
  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  add_index "delayed_jobs", ["queue"], name: "delayed_jobs_queue", using: :btree

  create_table "pathology_cases", force: :cascade do |t|
    t.string   "accession_number",    limit: 255
    t.string   "patient_last_name",   limit: 255,   null: false
    t.string   "patient_first_name",  limit: 255,   null: false
    t.string   "patient_middle_name", limit: 255
    t.string   "mrn",                 limit: 255
    t.string   "ssn",                 limit: 255
    t.date     "birth_date"
    t.string   "street1",             limit: 255
    t.string   "street2",             limit: 255
    t.string   "city",                limit: 255
    t.string   "state",               limit: 255
    t.string   "zip_code",            limit: 255
    t.string   "country",             limit: 255
    t.string   "home_phone",          limit: 255
    t.string   "sex",                 limit: 255
    t.string   "race",                limit: 255
    t.date     "collection_date",                   null: false
    t.string   "attending",           limit: 255
    t.string   "surgeon",             limit: 255
    t.text     "note",                limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_assignments", force: :cascade do |t|
    t.integer  "role_id",    limit: 4, null: false
    t.integer  "user_id",    limit: 4, null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",                limit: 255, null: false
    t.string   "external_identifier", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sql_audits", force: :cascade do |t|
    t.string   "username",       limit: 255,   null: false
    t.string   "auditable_type", limit: 255
    t.text     "auditable_ids",  limit: 65535
    t.text     "sql",            limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "username",               limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token",   limit: 255
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,   null: false
    t.integer  "item_id",    limit: 4,     null: false
    t.string   "event",      limit: 255,   null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 65535
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
