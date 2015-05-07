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

ActiveRecord::Schema.define(version: 20150506013332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abstractor_abstraction_group_members", force: :cascade do |t|
    t.integer  "abstractor_abstraction_group_id"
    t.integer  "abstractor_abstraction_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abstractor_abstraction_group_members", ["abstractor_abstraction_group_id"], name: "index_abstractor_abstraction_group_id", using: :btree
  add_index "abstractor_abstraction_group_members", ["abstractor_abstraction_id"], name: "index_abstractor_abstraction_id", using: :btree

  create_table "abstractor_abstraction_groups", force: :cascade do |t|
    t.integer  "abstractor_subject_group_id"
    t.string   "about_type"
    t.integer  "about_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "system_generated",            default: false
  end

  add_index "abstractor_abstraction_groups", ["about_id", "about_type", "deleted_at"], name: "index_about_id_about_type_deleted_at", using: :btree

  create_table "abstractor_abstraction_schema_object_values", force: :cascade do |t|
    t.integer  "abstractor_abstraction_schema_id"
    t.integer  "abstractor_object_value_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_schema_predicate_variants", force: :cascade do |t|
    t.integer  "abstractor_abstraction_schema_id"
    t.string   "value"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_schema_relations", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "object_id"
    t.integer  "abstractor_relation_type_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_schemas", force: :cascade do |t|
    t.string   "predicate"
    t.string   "display_name"
    t.integer  "abstractor_object_type_id"
    t.string   "preferred_name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_source_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_abstraction_sources", force: :cascade do |t|
    t.integer  "abstractor_subject_id"
    t.string   "from_method"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "custom_method"
    t.integer  "abstractor_abstraction_source_type_id"
    t.integer  "abstractor_rule_type_id"
    t.string   "section_name"
    t.string   "custom_nlp_provider"
  end

  create_table "abstractor_abstractions", force: :cascade do |t|
    t.integer  "abstractor_subject_id"
    t.string   "value"
    t.string   "about_type"
    t.integer  "about_id"
    t.boolean  "unknown"
    t.boolean  "not_applicable"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abstractor_abstractions", ["about_id", "about_type", "deleted_at"], name: "index_about_id_about_type_deleted_at_2", using: :btree
  add_index "abstractor_abstractions", ["abstractor_subject_id"], name: "index_abstractor_subject_id", using: :btree

  create_table "abstractor_indirect_sources", force: :cascade do |t|
    t.integer  "abstractor_abstraction_id"
    t.integer  "abstractor_abstraction_source_id"
    t.string   "source_type"
    t.integer  "source_id"
    t.string   "source_method"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_object_types", force: :cascade do |t|
    t.string   "value"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_object_value_variants", force: :cascade do |t|
    t.integer  "abstractor_object_value_id"
    t.string   "value"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_object_values", force: :cascade do |t|
    t.string   "value"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "properties"
    t.string   "vocabulary_code"
    t.string   "vocabulary"
    t.string   "vocabulary_version"
  end

  create_table "abstractor_relation_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_rule_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_section_name_variants", force: :cascade do |t|
    t.integer  "abstractor_section_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_section_types", force: :cascade do |t|
    t.string   "name"
    t.string   "regular_expression"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_sections", force: :cascade do |t|
    t.integer  "abstractor_section_type_id"
    t.string   "source_type"
    t.string   "source_method"
    t.string   "name"
    t.string   "description"
    t.string   "delimiter"
    t.string   "custom_regular_expression"
    t.boolean  "return_note_on_empty_section"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_subject_group_members", force: :cascade do |t|
    t.integer  "abstractor_subject_id"
    t.integer  "abstractor_subject_group_id"
    t.integer  "display_order"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abstractor_subject_group_members", ["abstractor_subject_id"], name: "index_abstractor_subject_id_2", using: :btree

  create_table "abstractor_subject_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cardinality"
  end

  create_table "abstractor_subject_relations", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "object_id"
    t.integer  "abstractor_relation_type_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_subjects", force: :cascade do |t|
    t.integer  "abstractor_abstraction_schema_id"
    t.string   "subject_type"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dynamic_list_method"
    t.string   "namespace_type"
    t.integer  "namespace_id"
  end

  add_index "abstractor_subjects", ["namespace_type", "namespace_id"], name: "index_namespace_type_namespace_id", using: :btree
  add_index "abstractor_subjects", ["subject_type"], name: "index_subject_type", using: :btree

  create_table "abstractor_suggestion_object_values", force: :cascade do |t|
    t.integer  "abstractor_suggestion_id"
    t.integer  "abstractor_object_value_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_suggestion_sources", force: :cascade do |t|
    t.integer  "abstractor_abstraction_source_id"
    t.integer  "abstractor_suggestion_id"
    t.text     "match_value"
    t.text     "sentence_match_value"
    t.integer  "source_id"
    t.string   "source_method"
    t.string   "source_type"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "custom_method"
    t.string   "custom_explanation"
    t.string   "section_name"
  end

  add_index "abstractor_suggestion_sources", ["abstractor_suggestion_id"], name: "index_abstractor_suggestion_id", using: :btree

  create_table "abstractor_suggestion_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abstractor_suggestions", force: :cascade do |t|
    t.integer  "abstractor_abstraction_id"
    t.integer  "abstractor_suggestion_status_id"
    t.string   "suggested_value"
    t.boolean  "unknown"
    t.boolean  "not_applicable"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abstractor_suggestions", ["abstractor_abstraction_id"], name: "index_abstractor_abstraction_id_2", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "pathology_cases", force: :cascade do |t|
    t.string   "accession_number"
    t.string   "patient_last_name",   null: false
    t.string   "patient_first_name",  null: false
    t.string   "patient_middle_name"
    t.string   "mrn",                 null: false
    t.string   "ssn"
    t.date     "birth_date",          null: false
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "home_phone"
    t.string   "gender"
    t.date     "encounter_date",      null: false
    t.text     "note",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sql_audits", force: :cascade do |t|
    t.string   "username",       null: false
    t.string   "auditable_type"
    t.text     "auditable_ids"
    t.text     "sql",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
