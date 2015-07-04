class MetriqRecord < Fixy::Record
  include Fixy::Formatter::Alphanumeric
  set_record_length 22824
  set_line_ending Fixy::Record::LINE_ENDING_CRLF

  def initialize(patient_last_name, patient_first_name, primary_site_icd_o_3, primary_histology_icd_o_3, medical_record_number, social_security_number, addr_no_and_street, city, state, zip_code, telephone, birth_date, sex)
    @patient_last_name = patient_last_name
    @patient_first_name = patient_first_name
    @primary_site_icd_o_3 = primary_site_icd_o_3.blank? ? nil : primary_site_icd_o_3.gsub('.','')
    @primary_histology_icd_o_3 = primary_histology_icd_o_3.blank? ? nil : primary_histology_icd_o_3.gsub('/','')
    @medical_record_number = itegerify(medical_record_number)
    @social_security_number = itegerify(social_security_number) || '999999999'
    @addr_no_and_street = addr_no_and_street.upcase
    @city = city.upcase if city
    @state = state.upcase if state
    @zip_code = itegerify(zip_code)
    @telephone = itegerify(telephone) || '9999999999'
    @birth_date = birth_date.blank? ? nil : birth_date.strftime("%Y%m%d")
    @sex = map_sex(sex)
  end

  def itegerify(token)
    token.blank? ? nil : token.gsub(/\D/, '')
  end

  # 1 Male
  # 2 Female
  # 3 Other
  # 4 Transsexual
  # 9 Unknown

  def map_sex(sex)
    case sex
    when 'F'
      '2'
    when 'M'
      '1'
    else
      nil
    end
  end

  field :record_type, 1, '1-1', :alphanumeric
  field :registry_type, 1, '2-2', :alphanumeric
  field :reserved_00, 14, '3-16', :alphanumeric
  field :naaccr_record_version, 3, '17-19', :alphanumeric
  field :npi_registry_id, 10, '20-29', :alphanumeric
  field :registry_id, 10, '30-39', :alphanumeric
  field :tumor_record_number, 2, '40-41', :alphanumeric
  field :patient_id_number, 8, '42-49', :alphanumeric
  field :patient_system_id_hosp, 8, '50-57', :alphanumeric
  field :reserved_01, 37, '58-94', :alphanumeric
  field :addr_at_dx_city, 50, '95-144', :alphanumeric
  field :addr_at_dx_state, 2, '145-146', :alphanumeric
  field :addr_at_dx_postal_code, 9, '147-155', :alphanumeric
  field :county_at_dx, 3, '156-158', :alphanumeric
  field :census_tract_1970_80_90, 6, '159-164', :alphanumeric
  field :census_block_grp_1970_90, 1, '165-165', :alphanumeric
  field :census_cod_sys_1970_80_90, 1, '166-166', :alphanumeric
  field :census_tr_cert_1970_80_90, 1, '167-167', :alphanumeric
  field :census_tract_2000, 6, '168-173', :alphanumeric
  field :census_block_group_2000, 1, '174-174', :alphanumeric
  field :census_tr_certainty_2000, 1, '175-175', :alphanumeric
  field :marital_status_at_dx, 1, '176-176', :alphanumeric
  field :race_1, 2, '177-178', :alphanumeric
  field :race_2, 2, '179-180', :alphanumeric
  field :race_3, 2, '181-182', :alphanumeric
  field :race_4, 2, '183-184', :alphanumeric
  field :race_5, 2, '185-186', :alphanumeric
  field :race_coding_sys_current, 1, '187-187', :alphanumeric
  field :race_coding_sys_original, 1, '188-188', :alphanumeric
  field :spanish_hispanic_origin, 1, '189-189', :alphanumeric
  field :computed_ethnicity, 1, '190-190', :alphanumeric
  field :computed_ethnicity_source, 1, '191-191', :alphanumeric
  field :sex, 1, '192-192', :alphanumeric
  field :age_at_diagnosis, 3, '193-195', :alphanumeric
  field :date_of_birth, 8, '196-203', :alphanumeric
  field :date_of_birth_flag, 2, '204-205', :alphanumeric
  field :birthplace, 3, '206-208', :alphanumeric
  field :census_occ_code_1970_2000, 3, '209-211', :alphanumeric
  field :census_ind_code_1970_2000, 3, '212-214', :alphanumeric
  field :occupation_source, 1, '215-215', :alphanumeric
  field :industry_source, 1, '216-216', :alphanumeric
  field :text_usual_occupation, 100, '217-316', :alphanumeric
  field :text_usual_industry, 100, '317-416', :alphanumeric
  field :census_occ_ind_sys_70_00, 1, '417-417', :alphanumeric
  field :nhia_derived_hisp_origin, 1, '418-418', :alphanumeric
  field :race_napiia_derived_api_, 2, '419-420', :alphanumeric
  field :ihs_link, 1, '421-421', :alphanumeric
  field :gis_coordinate_quality, 2, '422-423', :alphanumeric
  field :ruralurban_continuum_1993, 2, '424-425', :alphanumeric
  field :ruralurban_continuum_2003, 2, '426-427', :alphanumeric
  field :census_tract_2010, 6, '428-433', :alphanumeric
  field :census_block_group_2010, 1, '434-434', :alphanumeric
  field :census_tr_certainty_2010, 1, '435-435', :alphanumeric
  field :addr_at_dx_country, 3, '436-438', :alphanumeric
  field :addr_current_country, 3, '439-441', :alphanumeric
  field :birthplace_state, 2, '442-443', :alphanumeric
  field :birthplace_country, 3, '444-446', :alphanumeric
  field :followup_contact_country, 3, '447-449', :alphanumeric
  field :place_of_death_state, 2, '450-451', :alphanumeric
  field :place_of_death_country, 3, '452-454', :alphanumeric
  field :census_ind_code_2010, 4, '455-458', :alphanumeric
  field :census_occ_code_2010, 4, '459-462', :alphanumeric
  field :census_tr_poverty_indictr, 1, '463-463', :alphanumeric
  field :reserved_02, 64, '464-527', :alphanumeric
  field :sequence_number_central, 2, '528-529', :alphanumeric
  field :date_of_diagnosis, 8, '530-537', :alphanumeric
  field :date_of_diagnosis_flag, 2, '538-539', :alphanumeric
  field :primary_site, 4, '540-543', :alphanumeric
  field :laterality, 1, '544-544', :alphanumeric
  field :morph_type_behav_icd_o_2, 5, '545-549', :alphanumeric
  # field :histology_92_00_icd_o_2, 4, '545-548', :alphanumeric
  # field :behavior_92_00_icd_o_2, 1, '549-549', :alphanumeric
  # field :histologic_type_icd_o_3, 4, '550-553', :alphanumeric
  field :morph_type_behav_icd_o_3, 5, '550-554', :alphanumeric
  # field :behavior_code_icd_o_3, 1, '554-554', :alphanumeric
  field :grade, 1, '555-555', :alphanumeric
  field :grade_path_value, 1, '556-556', :alphanumeric
  field :grade_path_system, 1, '557-557', :alphanumeric
  field :site_coding_sys_current, 1, '558-558', :alphanumeric
  field :site_coding_sys_original, 1, '559-559', :alphanumeric
  field :morph_coding_sys_current, 1, '560-560', :alphanumeric
  field :morph_coding_sys_originl, 1, '561-561', :alphanumeric
  field :diagnostic_confirmation, 1, '562-562', :alphanumeric
  field :type_of_reporting_source, 1, '563-563', :alphanumeric
  field :casefinding_source, 2, '564-565', :alphanumeric
  field :ambiguous_terminology_dx, 1, '566-566', :alphanumeric
  field :date_conclusive_dx, 8, '567-574', :alphanumeric
  field :date_conclusive_dx_flag, 2, '575-576', :alphanumeric
  field :mult_tum_rpt_as_one_prim, 2, '577-578', :alphanumeric
  field :date_of_mult_tumors, 8, '579-586', :alphanumeric
  field :date_of_mult_tumors_flag, 2, '587-588', :alphanumeric
  field :multiplicity_counter, 2, '589-590', :alphanumeric
  field :reserved_03, 100, '591-690', :alphanumeric
  field :npi_reporting_facility, 10, '691-700', :alphanumeric
  field :reporting_facility, 10, '701-710', :alphanumeric
  field :npi_archive_fin, 10, '711-720', :alphanumeric
  field :archive_fin, 10, '721-730', :alphanumeric
  field :accession_number_hosp, 9, '731-739', :alphanumeric
  field :sequence_number_hospital, 2, '740-741', :alphanumeric
  field :abstracted_by, 3, '742-744', :alphanumeric
  field :date_of_1st_contact, 8, '745-752', :alphanumeric
  field :date_of_1st_contact_flag, 2, '753-754', :alphanumeric
  field :date_of_inpt_adm, 8, '755-762', :alphanumeric
  field :date_of_inpt_adm_flag, 2, '763-764', :alphanumeric
  field :date_of_inpt_disch, 8, '765-772', :alphanumeric
  field :date_of_inpt_disch_flag, 2, '773-774', :alphanumeric
  field :inpatient_status, 1, '775-775', :alphanumeric
  field :class_of_case, 2, '776-777', :alphanumeric
  field :primary_payer_at_dx, 2, '778-779', :alphanumeric
  field :reserved_15, 1, '780-780', :alphanumeric
  field :rx_hosp_surg_app_2010, 1, '781-781', :alphanumeric
  field :rx_hosp_surg_prim_site, 2, '782-783', :alphanumeric
  field :rx_hosp_scope_reg_ln_sur, 1, '784-784', :alphanumeric
  field :rx_hosp_surg_oth_reg_dis, 1, '785-785', :alphanumeric
  field :rx_hosp_reg_ln_removed, 2, '786-787', :alphanumeric
  field :reserved_16, 1, '788-788', :alphanumeric
  field :rx_hosp_radiation, 1, '789-789', :alphanumeric
  field :rx_hosp_chemo, 2, '790-791', :alphanumeric
  field :rx_hosp_hormone, 2, '792-793', :alphanumeric
  field :rx_hosp_brm, 2, '794-795', :alphanumeric
  field :rx_hosp_other, 1, '796-796', :alphanumeric
  field :rx_hosp_dx_stg_proc, 2, '797-798', :alphanumeric
  field :rx_hosp_palliative_proc, 1, '799-799', :alphanumeric
  field :rx_hosp_surg_site_98_02, 2, '800-801', :alphanumeric
  field :rx_hosp_scope_reg_98_02, 1, '802-802', :alphanumeric
  field :rx_hosp_surg_oth_98_02, 1, '803-803', :alphanumeric
  field :reserved_04, 100, '804-903', :alphanumeric
  field :seer_summary_stage_2000, 1, '904-904', :alphanumeric
  field :seer_summary_stage_1977, 1, '905-905', :alphanumeric
  # field :eod_tumor_size, 3, '906-908', :alphanumeric
  field :extent_of_disease_10_dig, 12, '906-917', :alphanumeric
  # field :eod_extension, 2, '909-910', :alphanumeric
  # field :eod_extension_prost_path, 2, '911-912', :alphanumeric
  # field :eod_lymph_node_involv, 1, '913-913', :alphanumeric
  # field :regional_nodes_positive, 2, '914-915', :alphanumeric
  # field :regional_nodes_examined, 2, '916-917', :alphanumeric
  field :eod_old_13_digit, 13, '918-930', :alphanumeric
  field :eod_old_2_digit, 2, '931-932', :alphanumeric
  field :eod_old_4_digit, 4, '933-936', :alphanumeric
  field :coding_system_for_eod, 1, '937-937', :alphanumeric
  field :tnm_edition_number, 2, '938-939', :alphanumeric
  field :tnm_path_t, 4, '940-943', :alphanumeric
  field :tnm_path_n, 4, '944-947', :alphanumeric
  field :tnm_path_m, 4, '948-951', :alphanumeric
  field :tnm_path_stage_group, 4, '952-955', :alphanumeric
  field :tnm_path_descriptor, 1, '956-956', :alphanumeric
  field :tnm_path_staged_by, 1, '957-957', :alphanumeric
  field :tnm_clin_t, 4, '958-961', :alphanumeric
  field :tnm_clin_n, 4, '962-965', :alphanumeric
  field :tnm_clin_m, 4, '966-969', :alphanumeric
  field :tnm_clin_stage_group, 4, '970-973', :alphanumeric
  field :tnm_clin_descriptor, 1, '974-974', :alphanumeric
  field :tnm_clin_staged_by, 1, '975-975', :alphanumeric
  field :pediatric_stage, 2, '976-977', :alphanumeric
  field :pediatric_staging_system, 2, '978-979', :alphanumeric
  field :pediatric_staged_by, 1, '980-980', :alphanumeric
  field :tumor_marker_1, 1, '981-981', :alphanumeric
  field :tumor_marker_2, 1, '982-982', :alphanumeric
  field :tumor_marker_3, 1, '983-983', :alphanumeric
  field :lymph_vascular_invasion, 1, '984-984', :alphanumeric
  field :cs_tumor_size, 3, '985-987', :alphanumeric
  field :cs_extension, 3, '988-990', :alphanumeric
  field :cs_tumor_size_ext_eval, 1, '991-991', :alphanumeric
  field :cs_lymph_nodes, 3, '992-994', :alphanumeric
  field :cs_lymph_nodes_eval, 1, '995-995', :alphanumeric
  field :cs_mets_at_dx, 2, '996-997', :alphanumeric
  field :cs_mets_eval, 1, '998-998', :alphanumeric
  field :cs_mets_at_dx_bone, 1, '999-999', :alphanumeric
  field :cs_mets_at_dx_brain, 1, '1000-1000', :alphanumeric
  field :cs_mets_at_dx_liver, 1, '1001-1001', :alphanumeric
  field :cs_mets_at_dx_lung, 1, '1002-1002', :alphanumeric
  field :cs_site_specific_factor_1, 3, '1003-1005', :alphanumeric
  field :cs_site_specific_factor_2, 3, '1006-1008', :alphanumeric
  field :cs_site_specific_factor_3, 3, '1009-1011', :alphanumeric
  field :cs_site_specific_factor_4, 3, '1012-1014', :alphanumeric
  field :cs_site_specific_factor_5, 3, '1015-1017', :alphanumeric
  field :cs_site_specific_factor_6, 3, '1018-1020', :alphanumeric
  field :cs_site_specific_factor_7, 3, '1021-1023', :alphanumeric
  field :cs_site_specific_factor_8, 3, '1024-1026', :alphanumeric
  field :cs_site_specific_factor_9, 3, '1027-1029', :alphanumeric
  field :cs_site_specific_factor10, 3, '1030-1032', :alphanumeric
  field :cs_site_specific_factor11, 3, '1033-1035', :alphanumeric
  field :cs_site_specific_factor12, 3, '1036-1038', :alphanumeric
  field :cs_site_specific_factor13, 3, '1039-1041', :alphanumeric
  field :cs_site_specific_factor14, 3, '1042-1044', :alphanumeric
  field :cs_site_specific_factor15, 3, '1045-1047', :alphanumeric
  field :cs_site_specific_factor16, 3, '1048-1050', :alphanumeric
  field :cs_site_specific_factor17, 3, '1051-1053', :alphanumeric
  field :cs_site_specific_factor18, 3, '1054-1056', :alphanumeric
  field :cs_site_specific_factor19, 3, '1057-1059', :alphanumeric
  field :cs_site_specific_factor20, 3, '1060-1062', :alphanumeric
  field :cs_site_specific_factor21, 3, '1063-1065', :alphanumeric
  field :cs_site_specific_factor22, 3, '1066-1068', :alphanumeric
  field :cs_site_specific_factor23, 3, '1069-1071', :alphanumeric
  field :cs_site_specific_factor24, 3, '1072-1074', :alphanumeric
  field :cs_site_specific_factor25, 3, '1075-1077', :alphanumeric
  field :cs_prerx_tumor_size, 3, '1078-1080', :alphanumeric
  field :cs_prerx_extension, 3, '1081-1083', :alphanumeric
  field :cs_prerx_tum_sz_ext_eval, 1, '1084-1084', :alphanumeric
  field :cs_prerx_lymph_nodes, 3, '1085-1087', :alphanumeric
  field :cs_prerx_reg_nodes_eval, 1, '1088-1088', :alphanumeric
  field :cs_prerx_mets_at_dx, 2, '1089-1090', :alphanumeric
  field :cs_prerx_mets_eval, 1, '1091-1091', :alphanumeric
  field :cs_postrx_tumor_size, 3, '1092-1094', :alphanumeric
  field :cs_postrx_extension, 3, '1095-1097', :alphanumeric
  field :cs_postrx_lymph_nodes, 3, '1098-1100', :alphanumeric
  field :cs_postrx_mets_at_dx, 2, '1101-1102', :alphanumeric
  field :derived_ajcc_6_t, 2, '1103-1104', :alphanumeric
  field :derived_ajcc_6_t_descript, 1, '1105-1105', :alphanumeric
  field :derived_ajcc_6_n, 2, '1106-1107', :alphanumeric
  field :derived_ajcc_6_n_descript, 1, '1108-1108', :alphanumeric
  field :derived_ajcc_6_m, 2, '1109-1110', :alphanumeric
  field :derived_ajcc_6_m_descript, 1, '1111-1111', :alphanumeric
  field :derived_ajcc_6_stage_grp, 2, '1112-1113', :alphanumeric
  field :derived_ajcc_7_t, 3, '1114-1116', :alphanumeric
  field :derived_ajcc_7_t_descript, 1, '1117-1117', :alphanumeric
  field :derived_ajcc_7_n, 3, '1118-1120', :alphanumeric
  field :derived_ajcc_7_n_descript, 1, '1121-1121', :alphanumeric
  field :derived_ajcc_7_m, 3, '1122-1124', :alphanumeric
  field :derived_ajcc_7_m_descript, 1, '1125-1125', :alphanumeric
  field :derived_ajcc_7_stage_grp, 3, '1126-1128', :alphanumeric
  field :derived_prerx_7_t, 3, '1129-1131', :alphanumeric
  field :derived_prerx_7_t_descrip, 1, '1132-1132', :alphanumeric
  field :derived_prerx_7_n, 3, '1133-1135', :alphanumeric
  field :derived_prerx_7_n_descrip, 1, '1136-1136', :alphanumeric
  field :derived_prerx_7_m, 3, '1137-1139', :alphanumeric
  field :derived_prerx_7_m_descrip, 1, '1140-1140', :alphanumeric
  field :derived_prerx_7_stage_grp, 3, '1141-1143', :alphanumeric
  field :derived_postrx_7_t, 3, '1144-1146', :alphanumeric
  field :derived_postrx_7_n, 3, '1147-1149', :alphanumeric
  field :derived_postrx_7_m, 2, '1150-1151', :alphanumeric
  field :derived_postrx_7_stge_grp, 3, '1152-1154', :alphanumeric
  field :derived_ss1977, 1, '1155-1155', :alphanumeric
  field :derived_ss2000, 1, '1156-1156', :alphanumeric
  field :derived_neoadjuv_rx_flag, 1, '1157-1157', :alphanumeric
  field :derived_ajcc_flag, 1, '1158-1158', :alphanumeric
  field :derived_ss1977_flag, 1, '1159-1159', :alphanumeric
  field :derived_ss2000_flag, 1, '1160-1160', :alphanumeric
  field :cs_version_input_current, 6, '1161-1166', :alphanumeric
  field :cs_version_input_original, 6, '1167-1172', :alphanumeric
  field :cs_version_derived, 6, '1173-1178', :alphanumeric
  field :seer_site_specific_fact_1, 1, '1179-1179', :alphanumeric
  field :seer_site_specific_fact_2, 1, '1180-1180', :alphanumeric
  field :seer_site_specific_fact_3, 1, '1181-1181', :alphanumeric
  field :seer_site_specific_fact_4, 1, '1182-1182', :alphanumeric
  field :seer_site_specific_fact_5, 1, '1183-1183', :alphanumeric
  field :seer_site_specific_fact_6, 1, '1184-1184', :alphanumeric
  field :icd_revision_comorbid, 1, '1185-1185', :alphanumeric
  field :comorbid_complication_1, 5, '1186-1190', :alphanumeric
  field :comorbid_complication_2, 5, '1191-1195', :alphanumeric
  field :comorbid_complication_3, 5, '1196-1200', :alphanumeric
  field :comorbid_complication_4, 5, '1201-1205', :alphanumeric
  field :comorbid_complication_5, 5, '1206-1210', :alphanumeric
  field :comorbid_complication_6, 5, '1211-1215', :alphanumeric
  field :comorbid_complication_7, 5, '1216-1220', :alphanumeric
  field :comorbid_complication_8, 5, '1221-1225', :alphanumeric
  field :comorbid_complication_9, 5, '1226-1230', :alphanumeric
  field :comorbid_complication_10, 5, '1231-1235', :alphanumeric
  field :secondary_diagnosis_1, 7, '1236-1242', :alphanumeric
  field :secondary_diagnosis_2, 7, '1243-1249', :alphanumeric
  field :secondary_diagnosis_3, 7, '1250-1256', :alphanumeric
  field :secondary_diagnosis_4, 7, '1257-1263', :alphanumeric
  field :secondary_diagnosis_5, 7, '1264-1270', :alphanumeric
  field :secondary_diagnosis_6, 7, '1271-1277', :alphanumeric
  field :secondary_diagnosis_7, 7, '1278-1284', :alphanumeric
  field :secondary_diagnosis_8, 7, '1285-1291', :alphanumeric
  field :secondary_diagnosis_9, 7, '1292-1298', :alphanumeric
  field :secondary_diagnosis_10, 7, '1299-1305', :alphanumeric
  field :npcr_specific_field, 75, '1306-1380', :alphanumeric
  field :reserved_05, 55, '1381-1435', :alphanumeric
  field :date_initial_rx_seer, 8, '1436-1443', :alphanumeric
  field :date_initial_rx_seer_flag, 2, '1444-1445', :alphanumeric
  field :date_1st_crs_rx_coc, 8, '1446-1453', :alphanumeric
  field :date_1st_crs_rx_coc_flag, 2, '1454-1455', :alphanumeric
  field :rx_date_surgery, 8, '1456-1463', :alphanumeric
  field :rx_date_surgery_flag, 2, '1464-1465', :alphanumeric
  field :rx_date_mst_defn_srg, 8, '1466-1473', :alphanumeric
  field :rx_date_mst_defn_srg_flag, 2, '1474-1475', :alphanumeric
  field :rx_date_surg_disch, 8, '1476-1483', :alphanumeric
  field :rx_date_surg_disch_flag, 2, '1484-1485', :alphanumeric
  field :rx_date_radiation, 8, '1486-1493', :alphanumeric
  field :rx_date_radiation_flag, 2, '1494-1495', :alphanumeric
  field :rx_date_rad_ended, 8, '1496-1503', :alphanumeric
  field :rx_date_rad_ended_flag, 2, '1504-1505', :alphanumeric
  field :rx_date_systemic, 8, '1506-1513', :alphanumeric
  field :rx_date_systemic_flag, 2, '1514-1515', :alphanumeric
  field :rx_date_chemo, 8, '1516-1523', :alphanumeric
  field :rx_date_chemo_flag, 2, '1524-1525', :alphanumeric
  field :rx_date_hormone, 8, '1526-1533', :alphanumeric
  field :rx_date_hormone_flag, 2, '1534-1535', :alphanumeric
  field :rx_date_brm, 8, '1536-1543', :alphanumeric
  field :rx_date_brm_flag, 2, '1544-1545', :alphanumeric
  field :rx_date_other, 8, '1546-1553', :alphanumeric
  field :rx_date_other_flag, 2, '1554-1555', :alphanumeric
  field :rx_date_dx_stg_proc, 8, '1556-1563', :alphanumeric
  field :rx_date_dx_stg_proc_flag, 2, '1564-1565', :alphanumeric
  field :rx_summ_treatment_status, 1, '1566-1566', :alphanumeric
  field :rx_summ_surg_prim_site, 2, '1567-1568', :alphanumeric
  field :rx_summ_scope_reg_ln_sur, 1, '1569-1569', :alphanumeric
  field :rx_summ_surg_oth_reg_dis, 1, '1570-1570', :alphanumeric
  field :rx_summ_reg_ln_examined, 2, '1571-1572', :alphanumeric
  field :rx_summ_surgical_approch, 1, '1573-1573', :alphanumeric
  field :rx_summ_surgical_margins, 1, '1574-1574', :alphanumeric
  field :rx_summ_reconstruct_1st, 1, '1575-1575', :alphanumeric
  field :reason_for_no_surgery, 1, '1576-1576', :alphanumeric
  field :rx_summ_dx_stg_proc, 2, '1577-1578', :alphanumeric
  field :rx_summ_palliative_proc, 1, '1579-1579', :alphanumeric
  field :rx_summ_radiation, 1, '1580-1580', :alphanumeric
  field :rx_summ_rad_to_cns, 1, '1581-1581', :alphanumeric
  field :rx_summ_surg_rad_seq, 1, '1582-1582', :alphanumeric
  field :rx_summ_transplnt_endocr, 2, '1583-1584', :alphanumeric
  field :rx_summ_chemo, 2, '1585-1586', :alphanumeric
  field :rx_summ_hormone, 2, '1587-1588', :alphanumeric
  field :rx_summ_brm, 2, '1589-1590', :alphanumeric
  field :rx_summ_other, 1, '1591-1591', :alphanumeric
  field :reason_for_no_radiation, 1, '1592-1592', :alphanumeric
  field :rx_coding_system_current, 2, '1593-1594', :alphanumeric
  field :reserved_18, 1, '1595-1595', :alphanumeric
  field :rad_regional_dose_cgy, 5, '1596-1600', :alphanumeric
  field :rad_no_of_treatment_vol, 3, '1601-1603', :alphanumeric
  field :rad_treatment_volume, 2, '1604-1605', :alphanumeric
  field :rad_location_of_rx, 1, '1606-1606', :alphanumeric
  field :rad_regional_rx_modality, 2, '1607-1608', :alphanumeric
  field :rad_boost_rx_modality, 2, '1609-1610', :alphanumeric
  field :rad_boost_dose_cgy, 5, '1611-1615', :alphanumeric
  field :rx_summ_systemic_sur_seq, 1, '1616-1616', :alphanumeric
  field :rx_summ_surgery_type, 2, '1617-1618', :alphanumeric
  field :readm_same_hosp_30_days, 1, '1619-1619', :alphanumeric
  field :rx_summ_surg_site_98_02, 2, '1620-1621', :alphanumeric
  field :rx_summ_scope_reg_98_02, 1, '1622-1622', :alphanumeric
  field :rx_summ_surg_oth_98_02, 1, '1623-1623', :alphanumeric
  field :reserved_06, 100, '1624-1723', :alphanumeric
  field :subsq_rx_2nd_course_date, 8, '1724-1731', :alphanumeric
  field :subsq_rx_2ndcrs_date_flag, 2, '1732-1733', :alphanumeric
  # field :subsq_rx_2nd_course_surg, 2, '1734-1735', :alphanumeric
  field :subsq_rx_2nd_course_codes, 11, '1734-1744', :alphanumeric
  # field :subsq_rx_2nd_scope_ln_su, 1, '1736-1736', :alphanumeric
  # field :subsq_rx_2nd_surg_oth, 1, '1737-1737', :alphanumeric
  # field :subsq_rx_2nd_reg_ln_rem, 2, '1738-1739', :alphanumeric
  # field :subsq_rx_2nd_course_rad, 1, '1740-1740', :alphanumeric
  # field :subsq_rx_2nd_course_chemo, 1, '1741-1741', :alphanumeric
  # field :subsq_rx_2nd_course_horm, 1, '1742-1742', :alphanumeric
  # field :subsq_rx_2nd_course_brm, 1, '1743-1743', :alphanumeric
  # field :subsq_rx_2nd_course_oth, 1, '1744-1744', :alphanumeric
  field :subsq_rx_3rd_course_date, 8, '1745-1752', :alphanumeric
  field :subsq_rx_3rdcrs_date_flag, 2, '1753-1754', :alphanumeric
  # field :subsq_rx_3rd_course_surg, 2, '1755-1756', :alphanumeric
  field :subsq_rx_3rd_course_codes, 11, '1755-1765', :alphanumeric
  # field :subsq_rx_3rd_scope_ln_su, 1, '1757-1757', :alphanumeric
  # field :subsq_rx_3rd_surg_oth, 1, '1758-1758', :alphanumeric
  # field :subsq_rx_3rd_reg_ln_rem, 2, '1759-1760', :alphanumeric
  # field :subsq_rx_3rd_course_rad, 1, '1761-1761', :alphanumeric
  # field :subsq_rx_3rd_course_chemo, 1, '1762-1762', :alphanumeric
  # field :subsq_rx_3rd_course_horm, 1, '1763-1763', :alphanumeric
  # field :subsq_rx_3rd_course_brm, 1, '1764-1764', :alphanumeric
  # field :subsq_rx_3rd_course_oth, 1, '1765-1765', :alphanumeric
  field :subsq_rx_4th_course_date, 8, '1766-1773', :alphanumeric
  field :subsq_rx_4thcrs_date_flag, 2, '1774-1775', :alphanumeric
  # field :subsq_rx_4th_course_surg, 2, '1776-1777', :alphanumeric
  field :subsq_rx_4th_course_codes, 11, '1776-1786', :alphanumeric
  # field :subsq_rx_4th_scope_ln_su, 1, '1778-1778', :alphanumeric
  # field :subsq_rx_4th_surg_oth, 1, '1779-1779', :alphanumeric
  # field :subsq_rx_4th_reg_ln_rem, 2, '1780-1781', :alphanumeric
  # field :subsq_rx_4th_course_rad, 1, '1782-1782', :alphanumeric
  # field :subsq_rx_4th_course_chemo, 1, '1783-1783', :alphanumeric
  # field :subsq_rx_4th_course_horm, 1, '1784-1784', :alphanumeric
  # field :subsq_rx_4th_course_brm, 1, '1785-1785', :alphanumeric
  # field :subsq_rx_4th_course_oth, 1, '1786-1786', :alphanumeric
  field :subsq_rx_reconstruct_del, 1, '1787-1787', :alphanumeric
  field :reserved_07, 100, '1788-1887', :alphanumeric
  field :over_ride_ss_nodespos, 1, '1888-1888', :alphanumeric
  field :over_ride_ss_tnm_n, 1, '1889-1889', :alphanumeric
  field :over_ride_ss_tnm_m, 1, '1890-1890', :alphanumeric
  field :over_ride_acsn_class_seq, 1, '1891-1891', :alphanumeric
  field :over_ride_hospseq_dxconf, 1, '1892-1892', :alphanumeric
  field :over_ride_coc_site_type, 1, '1893-1893', :alphanumeric
  field :over_ride_hospseq_site, 1, '1894-1894', :alphanumeric
  field :over_ride_site_tnm_stggrp, 1, '1895-1895', :alphanumeric
  field :over_ride_age_site_morph, 1, '1896-1896', :alphanumeric
  field :over_ride_seqno_dxconf, 1, '1897-1897', :alphanumeric
  field :over_ride_site_lat_seqno, 1, '1898-1898', :alphanumeric
  field :over_ride_surg_dxconf, 1, '1899-1899', :alphanumeric
  field :over_ride_site_type, 1, '1900-1900', :alphanumeric
  field :over_ride_histology, 1, '1901-1901', :alphanumeric
  field :over_ride_report_source, 1, '1902-1902', :alphanumeric
  field :over_ride_ill_define_site, 1, '1903-1903', :alphanumeric
  field :over_ride_leuk_lymphoma, 1, '1904-1904', :alphanumeric
  field :over_ride_site_behavior, 1, '1905-1905', :alphanumeric
  field :over_ride_site_eod_dx_dt, 1, '1906-1906', :alphanumeric
  field :over_ride_site_lat_eod, 1, '1907-1907', :alphanumeric
  field :over_ride_site_lat_morph, 1, '1908-1908', :alphanumeric
  field :site_73_91_icd_o_1, 4, '1909-1912', :alphanumeric
  field :morph_73_91_icd_o_1, 6, '1913-1918', :alphanumeric
  # field :histology_73_91_icd_o_1, 4, '1913-1916', :alphanumeric
  # field :behavior_73_91_icd_o_1, 1, '1917-1917', :alphanumeric
  # field :grade_73_91_icd_o_1, 1, '1918-1918', :alphanumeric
  field :icd_o_2_conversion_flag, 1, '1919-1919', :alphanumeric
  field :crc_checksum, 10, '1920-1929', :alphanumeric
  field :seer_coding_sys_current, 1, '1930-1930', :alphanumeric
  field :seer_coding_sys_original, 1, '1931-1931', :alphanumeric
  field :coc_coding_sys_current, 2, '1932-1933', :alphanumeric
  field :coc_coding_sys_original, 2, '1934-1935', :alphanumeric
  field :vendor_name, 10, '1936-1945', :alphanumeric
  field :seer_type_of_follow_up, 1, '1946-1946', :alphanumeric
  field :seer_record_number, 2, '1947-1948', :alphanumeric
  field :diagnostic_proc_73_87, 2, '1949-1950', :alphanumeric
  field :date_case_initiated, 8, '1951-1958', :alphanumeric
  field :date_case_completed, 8, '1959-1966', :alphanumeric
  field :date_case_completed_coc, 8, '1967-1974', :alphanumeric
  field :date_case_last_changed, 8, '1975-1982', :alphanumeric
  field :date_case_report_exported, 8, '1983-1990', :alphanumeric
  field :date_case_report_received, 8, '1991-1998', :alphanumeric
  field :date_case_report_loaded, 8, '1999-2006', :alphanumeric
  field :date_tumor_record_availbl, 8, '2007-2014', :alphanumeric
  field :icd_o_3_conversion_flag, 1, '2015-2015', :alphanumeric
  field :over_ride_cs_1, 1, '2016-2016', :alphanumeric
  field :over_ride_cs_2, 1, '2017-2017', :alphanumeric
  field :over_ride_cs_3, 1, '2018-2018', :alphanumeric
  field :over_ride_cs_4, 1, '2019-2019', :alphanumeric
  field :over_ride_cs_5, 1, '2020-2020', :alphanumeric
  field :over_ride_cs_6, 1, '2021-2021', :alphanumeric
  field :over_ride_cs_7, 1, '2022-2022', :alphanumeric
  field :over_ride_cs_8, 1, '2023-2023', :alphanumeric
  field :over_ride_cs_9, 1, '2024-2024', :alphanumeric
  field :over_ride_cs_10, 1, '2025-2025', :alphanumeric
  field :over_ride_cs_11, 1, '2026-2026', :alphanumeric
  field :over_ride_cs_12, 1, '2027-2027', :alphanumeric
  field :over_ride_cs_13, 1, '2028-2028', :alphanumeric
  field :over_ride_cs_14, 1, '2029-2029', :alphanumeric
  field :over_ride_cs_15, 1, '2030-2030', :alphanumeric
  field :over_ride_cs_16, 1, '2031-2031', :alphanumeric
  field :over_ride_cs_17, 1, '2032-2032', :alphanumeric
  field :over_ride_cs_18, 1, '2033-2033', :alphanumeric
  field :over_ride_cs_19, 1, '2034-2034', :alphanumeric
  field :over_ride_cs_20, 1, '2035-2035', :alphanumeric
  field :reserved_08, 80, '2036-2115', :alphanumeric
  field :date_of_last_contact, 8, '2116-2123', :alphanumeric
  field :date_of_last_contact_flag, 2, '2124-2125', :alphanumeric
  field :vital_status, 1, '2126-2126', :alphanumeric
  field :cancer_status, 1, '2127-2127', :alphanumeric
  field :quality_of_survival, 1, '2128-2128', :alphanumeric
  field :follow_up_source, 1, '2129-2129', :alphanumeric
  field :next_follow_up_source, 1, '2130-2130', :alphanumeric
  field :addr_current_city, 50, '2131-2180', :alphanumeric
  field :addr_current_state, 2, '2181-2182', :alphanumeric
  field :addr_current_postal_code, 9, '2183-2191', :alphanumeric
  field :county_current, 3, '2192-2194', :alphanumeric
  field :reserved_17, 1, '2195-2195', :alphanumeric
  field :recurrence_date_1st, 8, '2196-2203', :alphanumeric
  field :recurrence_date_1st_flag, 2, '2204-2205', :alphanumeric
  field :recurrence_type_1st, 2, '2206-2207', :alphanumeric
  field :follow_up_contact_city, 50, '2208-2257', :alphanumeric
  field :follow_up_contact_state, 2, '2258-2259', :alphanumeric
  field :follow_up_contact_postal, 9, '2260-2268', :alphanumeric
  field :cause_of_death, 4, '2269-2272', :alphanumeric
  field :icd_revision_number, 1, '2273-2273', :alphanumeric
  field :autopsy, 1, '2274-2274', :alphanumeric
  field :place_of_death, 3, '2275-2277', :alphanumeric
  field :follow_up_source_central, 2, '2278-2279', :alphanumeric
  field :date_of_death_canada, 8, '2280-2287', :alphanumeric
  field :date_of_death_canadaflag, 2, '2288-2289', :alphanumeric
  field :unusual_follow_up_method, 2, '2290-2291', :alphanumeric
  field :reserved_09, 48, '2292-2339', :alphanumeric
  field :state_requestor_items, 1000, '2340-3339', :alphanumeric
  field :name_last, 40, '3340-3379', :alphanumeric
  field :name_first, 40, '3380-3419', :alphanumeric
  field :name_middle, 40, '3420-3459', :alphanumeric
  field :name_prefix, 3, '3460-3462', :alphanumeric
  field :name_suffix, 3, '3463-3465', :alphanumeric
  field :name_alias, 40, '3466-3505', :alphanumeric
  field :name_maiden, 40, '3506-3545', :alphanumeric
  field :name_spouse_parent, 60, '3546-3605', :alphanumeric
  field :medical_record_number, 11, '3606-3616', :alphanumeric
  field :military_record_no_suffix, 2, '3617-3618', :alphanumeric
  field :social_security_number, 9, '3619-3627', :alphanumeric
  field :addr_at_dx_no_street, 60, '3628-3687', :alphanumeric
  field :addr_at_dx_supplementl, 60, '3688-3747', :alphanumeric
  field :addr_current_no_street, 60, '3748-3807', :alphanumeric
  field :addr_current_supplementl, 60, '3808-3867', :alphanumeric
  field :telephone, 10, '3868-3877', :alphanumeric
  field :dc_state_file_number, 6, '3878-3883', :alphanumeric
  field :follow_up_contact_name, 60, '3884-3943', :alphanumeric
  field :follow_up_contact_no_st, 60, '3944-4003', :alphanumeric
  field :follow_up_contact_suppl, 60, '4004-4063', :alphanumeric
  field :latitude, 10, '4064-4073', :alphanumeric
  field :longitude, 11, '4074-4084', :alphanumeric
  field :reserved_10, 200, '4085-4284', :alphanumeric
  field :npi_following_registry, 10, '4285-4294', :alphanumeric
  field :following_registry, 10, '4295-4304', :alphanumeric
  field :npi_inst_referred_from, 10, '4305-4314', :alphanumeric
  field :institution_referred_from, 10, '4315-4324', :alphanumeric
  field :npi_inst_referred_to, 10, '4325-4334', :alphanumeric
  field :institution_referred_to, 10, '4335-4344', :alphanumeric
  field :reserved_11, 50, '4345-4394', :alphanumeric
  field :npi_physician_managing, 10, '4395-4404', :alphanumeric
  field :physician_managing, 8, '4405-4412', :alphanumeric
  field :npi_physician_follow_up, 10, '4413-4422', :alphanumeric
  field :physician_follow_up, 8, '4423-4430', :alphanumeric
  field :npi_physician_primary_surg, 10, '4431-4440', :alphanumeric
  field :physician_primary_surg, 8, '4441-4448', :alphanumeric
  field :npi_physician_3, 10, '4449-4458', :alphanumeric
  field :physician_3, 8, '4459-4466', :alphanumeric
  field :npi_physician_4, 10, '4467-4476', :alphanumeric
  field :physician_4, 8, '4477-4484', :alphanumeric
  field :reserved_12, 50, '4485-4534', :alphanumeric
  field :path_reporting_fac_id_1, 25, '4535-4559', :alphanumeric
  field :path_report_number_1, 20, '4560-4579', :alphanumeric
  field :path_date_spec_collect_1, 14, '4580-4593', :alphanumeric
  field :path_report_type_1, 2, '4594-4595', :alphanumeric
  field :path_ordering_fac_no_1, 25, '4596-4620', :alphanumeric
  field :path_order_phys_lic_no_1, 20, '4621-4640', :alphanumeric
  field :path_reporting_fac_id_2, 25, '4641-4665', :alphanumeric
  field :path_report_number_2, 20, '4666-4685', :alphanumeric
  field :path_date_spec_collect_2, 14, '4686-4699', :alphanumeric
  field :path_report_type_2, 2, '4700-4701', :alphanumeric
  field :path_ordering_fac_no_2, 25, '4702-4726', :alphanumeric
  field :path_order_phys_lic_no_2, 20, '4727-4746', :alphanumeric
  field :path_reporting_fac_id_3, 25, '4747-4771', :alphanumeric
  field :path_report_number_3, 20, '4772-4791', :alphanumeric
  field :path_date_spec_collect_3, 14, '4792-4805', :alphanumeric
  field :path_report_type_3, 2, '4806-4807', :alphanumeric
  field :path_ordering_fac_no_3, 25, '4808-4832', :alphanumeric
  field :path_order_phys_lic_no_3, 20, '4833-4852', :alphanumeric
  field :path_reporting_fac_id_4, 25, '4853-4877', :alphanumeric
  field :path_report_number_4, 20, '4878-4897', :alphanumeric
  field :path_date_spec_collect_4, 14, '4898-4911', :alphanumeric
  field :path_report_type_4, 2, '4912-4913', :alphanumeric
  field :path_ordering_fac_no_4, 25, '4914-4938', :alphanumeric
  field :path_order_phys_lic_no_4, 20, '4939-4958', :alphanumeric
  field :path_reporting_fac_id_5, 25, '4959-4983', :alphanumeric
  field :path_report_number_5, 20, '4984-5003', :alphanumeric
  field :path_date_spec_collect_5, 14, '5004-5017', :alphanumeric
  field :path_report_type_5, 2, '5018-5019', :alphanumeric
  field :path_ordering_fac_no_5, 25, '5020-5044', :alphanumeric
  field :path_order_phys_lic_no_5, 20, '5045-5064', :alphanumeric
  field :reserved_13, 500, '5065-5564', :alphanumeric
  field :text_dx_proc_pe, 1000, '5565-6564', :alphanumeric
  field :text_dx_proc_x_ray_scan, 1000, '6565-7564', :alphanumeric
  field :text_dx_proc_scopes, 1000, '7565-8564', :alphanumeric
  field :text_dx_proc_lab_tests, 1000, '8565-9564', :alphanumeric
  field :text_dx_proc_op, 1000, '9565-10564', :alphanumeric
  field :text_dx_proc_path, 1000, '10565-11564', :alphanumeric
  field :text_primary_site_title, 100, '11565-11664', :alphanumeric
  field :text_histology_title, 100, '11665-11764', :alphanumeric
  field :text_staging, 1000, '11765-12764', :alphanumeric
  field :rx_text_surgery, 1000, '12765-13764', :alphanumeric
  field :rx_text_radiation_beam_, 1000, '13765-14764', :alphanumeric
  field :rx_text_radiation_other, 1000, '14765-15764', :alphanumeric
  field :rx_text_chemo, 1000, '15765-16764', :alphanumeric
  field :rx_text_hormone, 1000, '16765-17764', :alphanumeric
  field :rx_text_brm, 1000, '17765-18764', :alphanumeric
  field :rx_text_other, 1000, '18765-19764', :alphanumeric
  field :text_remarks, 1000, '19765-20764', :alphanumeric
  field :text_place_of_diagnosis, 60, '20765-20824', :alphanumeric
  field :reserved_14, 2000, '20825-22824', :alphanumeric

  field_value :record_type, ''
  field_value :registry_type, ''
  field_value :reserved_00,  ''
  field_value :naaccr_record_version, ''
  field_value :npi_registry_id, ''
  field_value :registry_id, ''
  field_value :tumor_record_number, ''
  field_value :patient_id_number, ''
  field_value :patient_system_id_hosp, ''
  field_value :reserved_01, ''
  field_value :addr_at_dx_city, ''
  field_value :addr_at_dx_state, ''
  field_value :addr_at_dx_postal_code, ''
  field_value :county_at_dx, ''
  field_value :census_tract_1970_80_90, ''
  field_value :census_block_grp_1970_90, ''
  field_value :census_cod_sys_1970_80_90, ''
  field_value :census_tr_cert_1970_80_90, ''
  field_value :census_tract_2000, ''
  field_value :census_block_group_2000, ''
  field_value :census_tr_certainty_2000, ''
  field_value :marital_status_at_dx, ''
  field_value :race_1, ''
  field_value :race_2, ''
  field_value :race_3, ''
  field_value :race_4, ''
  field_value :race_5, ''
  field_value :race_coding_sys_current, ''
  field_value :race_coding_sys_original, ''
  field_value :spanish_hispanic_origin, ''
  field_value :computed_ethnicity, ''
  field_value :computed_ethnicity_source, ''
  field_value :sex, -> { @sex }
  field_value :age_at_diagnosis, ''
  field_value :date_of_birth, -> { @birth_date }
  field_value :date_of_birth_flag, ''
  field_value :birthplace, ''
  field_value :census_occ_code_1970_2000, ''
  field_value :census_ind_code_1970_2000, ''
  field_value :occupation_source, ''
  field_value :industry_source, ''
  field_value :text_usual_occupation, ''
  field_value :text_usual_industry, ''
  field_value :census_occ_ind_sys_70_00, ''
  field_value :nhia_derived_hisp_origin, ''
  field_value :race_napiia_derived_api_, ''
  field_value :ihs_link, ''
  field_value :gis_coordinate_quality, ''
  field_value :ruralurban_continuum_1993, ''
  field_value :ruralurban_continuum_2003, ''
  field_value :census_tract_2010, ''
  field_value :census_block_group_2010, ''
  field_value :census_tr_certainty_2010, ''
  field_value :addr_at_dx_country, ''
  field_value :addr_current_country, ''
  field_value :birthplace_state, ''
  field_value :birthplace_country, ''
  field_value :followup_contact_country, ''
  field_value :place_of_death_state, ''
  field_value :place_of_death_country, ''
  field_value :census_ind_code_2010, ''
  field_value :census_occ_code_2010, ''
  field_value :census_tr_poverty_indictr, ''
  field_value :reserved_02, ''
  field_value :sequence_number_central, ''
  field_value :date_of_diagnosis, ''
  field_value :date_of_diagnosis_flag, ''
  field_value :primary_site, -> { @primary_site_icd_o_3 }
  field_value :laterality, ''
  field_value :morph_type_behav_icd_o_2, ''
  # field_value :histology_92_00_icd_o_2, ''
  # field_value :behavior_92_00_icd_o_2, ''
  # field_value :histologic_type_icd_o_3, ''
  field_value :morph_type_behav_icd_o_3, -> { @primary_histology_icd_o_3 }
  # field_value :behavior_code_icd_o_3, ''
  field_value :grade, ''
  field_value :grade_path_value, ''
  field_value :grade_path_system, ''
  field_value :site_coding_sys_current, ''
  field_value :site_coding_sys_original, ''
  field_value :morph_coding_sys_current, ''
  field_value :morph_coding_sys_originl, ''
  field_value :diagnostic_confirmation, ''
  field_value :type_of_reporting_source, ''
  field_value :casefinding_source, ''
  field_value :ambiguous_terminology_dx, ''
  field_value :date_conclusive_dx, ''
  field_value :date_conclusive_dx_flag, ''
  field_value :mult_tum_rpt_as_one_prim, ''
  field_value :date_of_mult_tumors, ''
  field_value :date_of_mult_tumors_flag, ''
  field_value :multiplicity_counter, ''
  field_value :reserved_03, ''
  field_value :npi_reporting_facility, ''
  field_value :reporting_facility, ''
  field_value :npi_archive_fin,  ''
  field_value :archive_fin, ''
  field_value :accession_number_hosp, ''
  field_value :sequence_number_hospital, ''
  field_value :abstracted_by, ''
  field_value :date_of_1st_contact, ''
  field_value :date_of_1st_contact_flag, ''
  field_value :date_of_inpt_adm, ''
  field_value :date_of_inpt_adm_flag, ''
  field_value :date_of_inpt_disch, ''
  field_value :date_of_inpt_disch_flag, ''
  field_value :inpatient_status, ''
  field_value :class_of_case, ''
  field_value :primary_payer_at_dx, ''
  field_value :reserved_15, ''
  field_value :rx_hosp_surg_app_2010, ''
  field_value :rx_hosp_surg_prim_site, ''
  field_value :rx_hosp_scope_reg_ln_sur, ''
  field_value :rx_hosp_surg_oth_reg_dis, ''
  field_value :rx_hosp_reg_ln_removed, ''
  field_value :reserved_16, ''
  field_value :rx_hosp_radiation, ''
  field_value :rx_hosp_chemo, ''
  field_value :rx_hosp_hormone, ''
  field_value :rx_hosp_brm, ''
  field_value :rx_hosp_other, ''
  field_value :rx_hosp_dx_stg_proc, ''
  field_value :rx_hosp_palliative_proc, ''
  field_value :rx_hosp_surg_site_98_02, ''
  field_value :rx_hosp_scope_reg_98_02, ''
  field_value :rx_hosp_surg_oth_98_02, ''
  field_value :reserved_04, ''
  field_value :seer_summary_stage_2000, ''
  field_value :seer_summary_stage_1977, ''
  # field_value :eod_tumor_size, ''
  field_value :extent_of_disease_10_dig, ''
  # field_value :eod_extension, ''
  # field_value :eod_extension_prost_path, ''
  # field_value :eod_lymph_node_involv, ''
  # field_value :regional_nodes_positive, ''
  # field_value :regional_nodes_examined, ''
  field_value :eod_old_13_digit, ''
  field_value :eod_old_2_digit, ''
  field_value :eod_old_4_digit, ''
  field_value :coding_system_for_eod, ''
  field_value :tnm_edition_number, ''
  field_value :tnm_path_t, ''
  field_value :tnm_path_n, ''
  field_value :tnm_path_m, ''
  field_value :tnm_path_stage_group, ''
  field_value :tnm_path_descriptor, ''
  field_value :tnm_path_staged_by, ''
  field_value :tnm_clin_t, ''
  field_value :tnm_clin_n, ''
  field_value :tnm_clin_m, ''
  field_value :tnm_clin_stage_group, ''
  field_value :tnm_clin_descriptor, ''
  field_value :tnm_clin_staged_by, ''
  field_value :pediatric_stage, ''
  field_value :pediatric_staging_system, ''
  field_value :pediatric_staged_by, ''
  field_value :tumor_marker_1, ''
  field_value :tumor_marker_2, ''
  field_value :tumor_marker_3, ''
  field_value :lymph_vascular_invasion, ''
  field_value :cs_tumor_size, ''
  field_value :cs_extension, ''
  field_value :cs_tumor_size_ext_eval, ''
  field_value :cs_lymph_nodes, ''
  field_value :cs_lymph_nodes_eval, ''
  field_value :cs_mets_at_dx, ''
  field_value :cs_mets_eval, ''
  field_value :cs_mets_at_dx_bone, ''
  field_value :cs_mets_at_dx_brain, ''
  field_value :cs_mets_at_dx_liver, ''
  field_value :cs_mets_at_dx_lung, ''
  field_value :cs_site_specific_factor_1, ''
  field_value :cs_site_specific_factor_2, ''
  field_value :cs_site_specific_factor_3, ''
  field_value :cs_site_specific_factor_4, ''
  field_value :cs_site_specific_factor_5, ''
  field_value :cs_site_specific_factor_6, ''
  field_value :cs_site_specific_factor_7, ''
  field_value :cs_site_specific_factor_8, ''
  field_value :cs_site_specific_factor_9, ''
  field_value :cs_site_specific_factor10, ''
  field_value :cs_site_specific_factor11, ''
  field_value :cs_site_specific_factor12, ''
  field_value :cs_site_specific_factor13, ''
  field_value :cs_site_specific_factor14, ''
  field_value :cs_site_specific_factor15, ''
  field_value :cs_site_specific_factor16, ''
  field_value :cs_site_specific_factor17, ''
  field_value :cs_site_specific_factor18, ''
  field_value :cs_site_specific_factor19, ''
  field_value :cs_site_specific_factor20, ''
  field_value :cs_site_specific_factor21, ''
  field_value :cs_site_specific_factor22, ''
  field_value :cs_site_specific_factor23, ''
  field_value :cs_site_specific_factor24, ''
  field_value :cs_site_specific_factor25, ''
  field_value :cs_prerx_tumor_size, ''
  field_value :cs_prerx_extension, ''
  field_value :cs_prerx_tum_sz_ext_eval, ''
  field_value :cs_prerx_lymph_nodes, ''
  field_value :cs_prerx_reg_nodes_eval, ''
  field_value :cs_prerx_mets_at_dx, ''
  field_value :cs_prerx_mets_eval, ''
  field_value :cs_postrx_tumor_size, ''
  field_value :cs_postrx_extension, ''
  field_value :cs_postrx_lymph_nodes, ''
  field_value :cs_postrx_mets_at_dx, ''
  field_value :derived_ajcc_6_t, ''
  field_value :derived_ajcc_6_t_descript, ''
  field_value :derived_ajcc_6_n, ''
  field_value :derived_ajcc_6_n_descript, ''
  field_value :derived_ajcc_6_m, ''
  field_value :derived_ajcc_6_m_descript, ''
  field_value :derived_ajcc_6_stage_grp, ''
  field_value :derived_ajcc_7_t, ''
  field_value :derived_ajcc_7_t_descript, ''
  field_value :derived_ajcc_7_n, ''
  field_value :derived_ajcc_7_n_descript, ''
  field_value :derived_ajcc_7_m, ''
  field_value :derived_ajcc_7_m_descript, ''
  field_value :derived_ajcc_7_stage_grp, ''
  field_value :derived_prerx_7_t, ''
  field_value :derived_prerx_7_t_descrip, ''
  field_value :derived_prerx_7_n, ''
  field_value :derived_prerx_7_n_descrip, ''
  field_value :derived_prerx_7_m, ''
  field_value :derived_prerx_7_m_descrip, ''
  field_value :derived_prerx_7_stage_grp, ''
  field_value :derived_postrx_7_t, ''
  field_value :derived_postrx_7_n, ''
  field_value :derived_postrx_7_m, ''
  field_value :derived_postrx_7_stge_grp, ''
  field_value :derived_ss1977, ''
  field_value :derived_ss2000, ''
  field_value :derived_neoadjuv_rx_flag, ''
  field_value :derived_ajcc_flag, ''
  field_value :derived_ss1977_flag, ''
  field_value :derived_ss2000_flag, ''
  field_value :cs_version_input_current, ''
  field_value :cs_version_input_original, ''
  field_value :cs_version_derived, ''
  field_value :seer_site_specific_fact_1, ''
  field_value :seer_site_specific_fact_2, ''
  field_value :seer_site_specific_fact_3, ''
  field_value :seer_site_specific_fact_4, ''
  field_value :seer_site_specific_fact_5, ''
  field_value :seer_site_specific_fact_6, ''
  field_value :icd_revision_comorbid, ''
  field_value :comorbid_complication_1, ''
  field_value :comorbid_complication_2, ''
  field_value :comorbid_complication_3, ''
  field_value :comorbid_complication_4, ''
  field_value :comorbid_complication_5, ''
  field_value :comorbid_complication_6, ''
  field_value :comorbid_complication_7, ''
  field_value :comorbid_complication_8, ''
  field_value :comorbid_complication_9, ''
  field_value :comorbid_complication_10, ''
  field_value :secondary_diagnosis_1, ''
  field_value :secondary_diagnosis_2, ''
  field_value :secondary_diagnosis_3, ''
  field_value :secondary_diagnosis_4, ''
  field_value :secondary_diagnosis_5, ''
  field_value :secondary_diagnosis_6, ''
  field_value :secondary_diagnosis_7, ''
  field_value :secondary_diagnosis_8, ''
  field_value :secondary_diagnosis_9, ''
  field_value :secondary_diagnosis_10, ''
  field_value :npcr_specific_field, ''
  field_value :reserved_05, ''
  field_value :date_initial_rx_seer, ''
  field_value :date_initial_rx_seer_flag, ''
  field_value :date_1st_crs_rx_coc, ''
  field_value :date_1st_crs_rx_coc_flag, ''
  field_value :rx_date_surgery, ''
  field_value :rx_date_surgery_flag, ''
  field_value :rx_date_mst_defn_srg, ''
  field_value :rx_date_mst_defn_srg_flag, ''
  field_value :rx_date_surg_disch, ''
  field_value :rx_date_surg_disch_flag, ''
  field_value :rx_date_radiation, ''
  field_value :rx_date_radiation_flag, ''
  field_value :rx_date_rad_ended, ''
  field_value :rx_date_rad_ended_flag, ''
  field_value :rx_date_systemic, ''
  field_value :rx_date_systemic_flag, ''
  field_value :rx_date_chemo, ''
  field_value :rx_date_chemo_flag, ''
  field_value :rx_date_hormone, ''
  field_value :rx_date_hormone_flag, ''
  field_value :rx_date_brm, ''
  field_value :rx_date_brm_flag, ''
  field_value :rx_date_other, ''
  field_value :rx_date_other_flag, ''
  field_value :rx_date_dx_stg_proc, ''
  field_value :rx_date_dx_stg_proc_flag, ''
  field_value :rx_summ_treatment_status, ''
  field_value :rx_summ_surg_prim_site, ''
  field_value :rx_summ_scope_reg_ln_sur, ''
  field_value :rx_summ_surg_oth_reg_dis, ''
  field_value :rx_summ_reg_ln_examined, ''
  field_value :rx_summ_surgical_approch, ''
  field_value :rx_summ_surgical_margins, ''
  field_value :rx_summ_reconstruct_1st, ''
  field_value :reason_for_no_surgery, ''
  field_value :rx_summ_dx_stg_proc,  ''
  field_value :rx_summ_palliative_proc, ''
  field_value :rx_summ_radiation, ''
  field_value :rx_summ_rad_to_cns, ''
  field_value :rx_summ_surg_rad_seq,  ''
  field_value :rx_summ_transplnt_endocr, ''
  field_value :rx_summ_chemo, ''
  field_value :rx_summ_hormone, ''
  field_value :rx_summ_brm, ''
  field_value :rx_summ_other, ''
  field_value :reason_for_no_radiation, ''
  field_value :rx_coding_system_current, ''
  field_value :reserved_18, ''
  field_value :rad_regional_dose_cgy, ''
  field_value :rad_no_of_treatment_vol, ''
  field_value :rad_treatment_volume, ''
  field_value :rad_location_of_rx, ''
  field_value :rad_regional_rx_modality, ''
  field_value :rad_boost_rx_modality, ''
  field_value :rad_boost_dose_cgy, ''
  field_value :rx_summ_systemic_sur_seq, ''
  field_value :rx_summ_surgery_type, ''
  field_value :readm_same_hosp_30_days, ''
  field_value :rx_summ_surg_site_98_02, ''
  field_value :rx_summ_scope_reg_98_02, ''
  field_value :rx_summ_surg_oth_98_02, ''
  field_value :reserved_06, ''
  field_value :subsq_rx_2nd_course_date, ''
  field_value :subsq_rx_2ndcrs_date_flag, ''
  # field_value :subsq_rx_2nd_course_surg, ''
  field_value :subsq_rx_2nd_course_codes, ''
  # field_value :subsq_rx_2nd_scope_ln_su, ''
  # field_value :subsq_rx_2nd_surg_oth, ''
  # field_value :subsq_rx_2nd_reg_ln_rem, ''
  # field_value :subsq_rx_2nd_course_rad, ''
  # field_value :subsq_rx_2nd_course_chemo,  ''
  # field_value :subsq_rx_2nd_course_horm, ''
  # field_value :subsq_rx_2nd_course_brm, ''
  # field_value :subsq_rx_2nd_course_oth, ''
  field_value :subsq_rx_3rd_course_date, ''
  field_value :subsq_rx_3rdcrs_date_flag, ''
  # field_value :subsq_rx_3rd_course_surg, ''
  field_value :subsq_rx_3rd_course_codes, ''
  # field_value :subsq_rx_3rd_scope_ln_su, ''
  # field_value :subsq_rx_3rd_surg_oth, ''
  # field_value :subsq_rx_3rd_reg_ln_rem, ''
  # field_value :subsq_rx_3rd_course_rad, ''
  # field_value :subsq_rx_3rd_course_chemo, ''
  # field_value :subsq_rx_3rd_course_horm, ''
  # field_value :subsq_rx_3rd_course_brm, ''
  # field_value :subsq_rx_3rd_course_oth, ''
  field_value :subsq_rx_4th_course_date, ''
  field_value :subsq_rx_4thcrs_date_flag, ''
  # field_value :subsq_rx_4th_course_surg, ''
  field_value :subsq_rx_4th_course_codes, ''
  # field_value :subsq_rx_4th_scope_ln_su, ''
  # field_value :subsq_rx_4th_surg_oth, ''
  # field_value :subsq_rx_4th_reg_ln_rem, ''
  # field_value :subsq_rx_4th_course_rad, ''
  # field_value :subsq_rx_4th_course_chemo, ''
  # field_value :subsq_rx_4th_course_horm, ''
  # field_value :subsq_rx_4th_course_brm, ''
  # field_value :subsq_rx_4th_course_oth, ''
  field_value :subsq_rx_reconstruct_del, ''
  field_value :reserved_07, ''
  field_value :over_ride_ss_nodespos, ''
  field_value :over_ride_ss_tnm_n, ''
  field_value :over_ride_ss_tnm_m, ''
  field_value :over_ride_acsn_class_seq, ''
  field_value :over_ride_hospseq_dxconf, ''
  field_value :over_ride_coc_site_type, ''
  field_value :over_ride_hospseq_site, ''
  field_value :over_ride_site_tnm_stggrp, ''
  field_value :over_ride_age_site_morph, ''
  field_value :over_ride_seqno_dxconf, ''
  field_value :over_ride_site_lat_seqno, ''
  field_value :over_ride_surg_dxconf, ''
  field_value :over_ride_site_type, ''
  field_value :over_ride_histology, ''
  field_value :over_ride_report_source, ''
  field_value :over_ride_ill_define_site, ''
  field_value :over_ride_leuk_lymphoma, ''
  field_value :over_ride_site_behavior, ''
  field_value :over_ride_site_eod_dx_dt, ''
  field_value :over_ride_site_lat_eod, ''
  field_value :over_ride_site_lat_morph, ''
  field_value :site_73_91_icd_o_1, ''
  field_value :morph_73_91_icd_o_1, ''
  # field_value :histology_73_91_icd_o_1, ''
  # field_value :behavior_73_91_icd_o_1, ''
  # field_value :grade_73_91_icd_o_1, ''
  field_value :icd_o_2_conversion_flag, ''
  field_value :crc_checksum, ''
  field_value :seer_coding_sys_current, ''
  field_value :seer_coding_sys_original, ''
  field_value :coc_coding_sys_current, ''
  field_value :coc_coding_sys_original, ''
  field_value :vendor_name, ''
  field_value :seer_type_of_follow_up, ''
  field_value :seer_record_number, ''
  field_value :diagnostic_proc_73_87, ''
  field_value :date_case_initiated, ''
  field_value :date_case_completed, ''
  field_value :date_case_completed_coc, ''
  field_value :date_case_last_changed, ''
  field_value :date_case_report_exported, ''
  field_value :date_case_report_received, ''
  field_value :date_case_report_loaded, ''
  field_value :date_tumor_record_availbl, ''
  field_value :icd_o_3_conversion_flag, ''
  field_value :over_ride_cs_1, ''
  field_value :over_ride_cs_2, ''
  field_value :over_ride_cs_3, ''
  field_value :over_ride_cs_4, ''
  field_value :over_ride_cs_5, ''
  field_value :over_ride_cs_6, ''
  field_value :over_ride_cs_7, ''
  field_value :over_ride_cs_8, ''
  field_value :over_ride_cs_9, ''
  field_value :over_ride_cs_10, ''
  field_value :over_ride_cs_11, ''
  field_value :over_ride_cs_12, ''
  field_value :over_ride_cs_13, ''
  field_value :over_ride_cs_14, ''
  field_value :over_ride_cs_15, ''
  field_value :over_ride_cs_16, ''
  field_value :over_ride_cs_17, ''
  field_value :over_ride_cs_18, ''
  field_value :over_ride_cs_19, ''
  field_value :over_ride_cs_20, ''
  field_value :reserved_08, ''
  field_value :date_of_last_contact, ''
  field_value :date_of_last_contact_flag, ''
  field_value :vital_status, ''
  field_value :cancer_status, ''
  field_value :quality_of_survival, ''
  field_value :follow_up_source, ''
  field_value :next_follow_up_source, ''
  field_value :addr_current_city, -> { @city }
  field_value :addr_current_state, -> { @state }
  field_value :addr_current_postal_code, -> { @zip_code }
  field_value :county_current, ''
  field_value :reserved_17, ''
  field_value :recurrence_date_1st,''
  field_value :recurrence_date_1st_flag, ''
  field_value :recurrence_type_1st, ''
  field_value :follow_up_contact_city, ''
  field_value :follow_up_contact_state, ''
  field_value :follow_up_contact_postal, ''
  field_value :cause_of_death, ''
  field_value :icd_revision_number, ''
  field_value :autopsy, ''
  field_value :place_of_death, ''
  field_value :follow_up_source_central, ''
  field_value :date_of_death_canada, ''
  field_value :date_of_death_canadaflag, ''
  field_value :unusual_follow_up_method, ''
  field_value :reserved_09, ''
  field_value :state_requestor_items, ''
  field_value :name_last, -> { @patient_last_name }
  field_value :name_first, -> { @patient_first_name }
  field_value :name_middle, ''
  field_value :name_prefix, ''
  field_value :name_suffix, ''
  field_value :name_alias, ''
  field_value :name_maiden, ''
  field_value :name_spouse_parent, ''
  field_value :medical_record_number, -> { @medical_record_number }
  field_value :military_record_no_suffix, ''
  field_value :social_security_number, -> { @social_security_number }
  field_value :addr_at_dx_no_street, ''
  field_value :addr_at_dx_supplementl, ''
  field_value :addr_current_no_street, -> { @addr_no_and_street }
  field_value :addr_current_supplementl, ''
  field_value :telephone, -> { @telephone }
  field_value :dc_state_file_number, ''
  field_value :follow_up_contact_name, ''
  field_value :follow_up_contact_no_st, ''
  field_value :follow_up_contact_suppl, ''
  field_value :latitude, ''
  field_value :longitude, ''
  field_value :reserved_10, ''
  field_value :npi_following_registry, ''
  field_value :following_registry, ''
  field_value :npi_inst_referred_from, ''
  field_value :institution_referred_from, ''
  field_value :npi_inst_referred_to, ''
  field_value :institution_referred_to, ''
  field_value :reserved_11, ''
  field_value :npi_physician_managing, ''
  field_value :physician_managing, ''
  field_value :npi_physician_follow_up, ''
  field_value :physician_follow_up, ''
  field_value :npi_physician_primary_surg, ''
  field_value :physician_primary_surg, ''
  field_value :npi_physician_3, ''
  field_value :physician_3, ''
  field_value :npi_physician_4, ''
  field_value :physician_4, ''
  field_value :reserved_12, ''
  field_value :path_reporting_fac_id_1, ''
  field_value :path_report_number_1, ''
  field_value :path_date_spec_collect_1, ''
  field_value :path_report_type_1, ''
  field_value :path_ordering_fac_no_1, ''
  field_value :path_order_phys_lic_no_1, ''
  field_value :path_reporting_fac_id_2, ''
  field_value :path_report_number_2, ''
  field_value :path_date_spec_collect_2, ''
  field_value :path_report_type_2, ''
  field_value :path_ordering_fac_no_2, ''
  field_value :path_order_phys_lic_no_2, ''
  field_value :path_reporting_fac_id_3, ''
  field_value :path_report_number_3, ''
  field_value :path_date_spec_collect_3, ''
  field_value :path_report_type_3, ''
  field_value :path_ordering_fac_no_3, ''
  field_value :path_order_phys_lic_no_3, ''
  field_value :path_reporting_fac_id_4, ''
  field_value :path_report_number_4, ''
  field_value :path_date_spec_collect_4, ''
  field_value :path_report_type_4, ''
  field_value :path_ordering_fac_no_4, ''
  field_value :path_order_phys_lic_no_4, ''
  field_value :path_reporting_fac_id_5, ''
  field_value :path_report_number_5, ''
  field_value :path_date_spec_collect_5, ''
  field_value :path_report_type_5, ''
  field_value :path_ordering_fac_no_5, ''
  field_value :path_order_phys_lic_no_5, ''
  field_value :reserved_13, ''
  field_value :text_dx_proc_pe, ''
  field_value :text_dx_proc_x_ray_scan, ''
  field_value :text_dx_proc_scopes, ''
  field_value :text_dx_proc_lab_tests, ''
  field_value :text_dx_proc_op, ''
  field_value :text_dx_proc_path, ''
  field_value :text_primary_site_title, ''
  field_value :text_histology_title, ''
  field_value :text_staging, ''
  field_value :rx_text_surgery, ''
  field_value :rx_text_radiation_beam_, ''
  field_value :rx_text_radiation_other, ''
  field_value :rx_text_chemo, ''
  field_value :rx_text_hormone, ''
  field_value :rx_text_brm, ''
  field_value :rx_text_other, ''
  field_value :text_remarks, ''
  field_value :text_place_of_diagnosis, ''
  field_value :reserved_14, ''
end