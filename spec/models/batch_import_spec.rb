require 'rails_helper'

RSpec.describe BatchImport, :type => :model do
  before(:all) do
    Abstractor::Setup.system
    source_type_nlp_suggestion = Abstractor::AbstractorAbstractionSourceType.where(name: 'nlp suggestion').first
    lightweight = true
    CaseFinder::Setup.setup_abstractor_schemas(source_type_nlp_suggestion, lightweight)
  end

  it 'imports and abstracts pathology cases from Excel', focus: false do
    expect(PathologyCase.count).to eq(0)
    batch_import = FactoryGirl.create(:excel_batch_import)
    batch_import.import
    expect(PathologyCase.count).to eq(2)
    pathology_case = PathologyCase.where(accession_number: 'EHS-15-11111').first
    expect(pathology_case).to_not be_nil
    expect(pathology_case.collection_date).to eq(Date.parse('08/01/2015'))
    expect(pathology_case.patient_last_name).to eq('MOOMIN')
    expect(pathology_case.patient_first_name).to eq('MOOMINTROLL')
    expect(pathology_case.mrn).to eq('011111111')
    expect(pathology_case.ssn).to eq('111111111')
    expect(pathology_case.birth_date).to eq(Date.parse('07/01/1976'))
    expect(pathology_case.street1).to eq('121 MAIN STREET')
    expect(pathology_case.street2).to eq('APT 1')
    expect(pathology_case.city).to eq('ANYWHERE')
    expect(pathology_case.state).to eq('IL')
    expect(pathology_case.zip_code).to eq('11111')
    expect(pathology_case.country).to eq('US')
    expect(pathology_case.home_phone).to eq('(111)111-1111')
    expect(pathology_case.sex).to eq('M')
    expect(pathology_case.race).to eq('W')
    expect(pathology_case.attending).to eq('DOCTOR MD, FAKE')
    expect(pathology_case.surgeon).to be_nil
    expect(pathology_case.note).to eq("Nature of Specimen:\r\nUrine, Voided\r\nClincal History: Hematuria\r\n\r\nDIAGNOSIS:\r\nSuspicious for transitional cell (urothelial) carcinoma.\r\n\r\nPathologist: Pathologist M.D., Fake  Report Date: 08/01/2015\r\n")
    expect(pathology_case.abstractor_abstractions.size).to eq(2)

    pathology_case = PathologyCase.where(accession_number: 'EHS-15-22222').first
    expect(pathology_case).to_not be_nil
    expect(pathology_case.collection_date).to eq(Date.parse('08/02/2015'))
    expect(pathology_case.patient_last_name).to eq('MOOMIN')
    expect(pathology_case.patient_first_name).to eq('MOOMINTROLL2')
    expect(pathology_case.mrn).to eq('022222222')
    expect(pathology_case.ssn).to eq('111111111')
    expect(pathology_case.birth_date).to eq(Date.parse('07/02/1976'))
    expect(pathology_case.street1).to eq('122 MAIN STREET')
    expect(pathology_case.street2).to eq('APT 2')
    expect(pathology_case.city).to eq('ANYWHERE2')
    expect(pathology_case.state).to eq('IL')
    expect(pathology_case.zip_code).to eq('22222')
    expect(pathology_case.country).to eq('US')
    expect(pathology_case.home_phone).to eq('(222)222-2222')
    expect(pathology_case.sex).to eq('M')
    expect(pathology_case.race).to eq('W')
    expect(pathology_case.attending).to eq('DOCTOR2 MD, FAKE')
    expect(pathology_case.surgeon).to eq('SURGEON MD, FAKE A')
    expect(pathology_case.note).to eq("Nature of Specimen:\r\nUterus and Cervix, Bilateral Tubes and Ovaries\r\nClincal History: None Given\r\n\r\nFINAL DIAGNOSIS:\r\nUterus and cervix, tubes and ovaries, total abdominal hysterectomy and bilateral salpingo-oophorectomy:\n\n- Endometrioid adenocarcinoma, well-differentiated (FIGO grade 1), with focal mucinous differentiation, arising in the background of complex atypical hyperplasia. See comment.\n\n- Tumor is confined to the endometrium.\n\n- Leiomyoma measuring 0.3 cm in greatest dimension.\n\n- Left paratubal cyst measuring 1.5 cm in greatest dimension.\n\n- Cervix, bilateral fallopian tubes and ovaries show no significant histopathologic abnormality.\n\n\n\n\n\nENDOMETRIAL CARCINOMA CASE SUMMARY NEW\n\nMacroscopic\n\nSpecimen:\tUterine corpus\n\nCervix\n\nLeft ovary\n\nRight ovary\n\nLeft fallopian tube\n\nRight fallopian tube\n\nProcedure:\tRadical hysterectomy\n\nBilateral salpingo-oophorectomy\n\nLymph node sampling:\tNot performed\n\nSpecimen integrity:\tIntact hysterectomy specimen\n\nPrimary tumor site:\tAnterior endometrium\n\nTumor size:\tGreatest dimension:\t1.5cm\n\nAdditional dimension(s):\t1.5cm x 0.2cm\n\nMicroscopic\n\nHistologic type:\tEndometrioid adenocarcinoma, not otherwise characterized\n\nHistologic grade:\tFIGO grade 1\n\nMyometrial invasion:\tNone identified\n\nInvolvement of cervix:\tNone identified\n\nAdnexal involvement:\tLeft ovary:\tNot involved\n\nRight ovary:\tNot involved\n\nLeft fallopian tube:\tNot involved\n\nRight fallopian tube:\tNot involved\n\nOther organ involvement:\tNot applicable\n\nPeritoneal fluid cytology:\tNegative for malignancy\n\nLymph-vascular invasion:\tNone identified\n\nPathologic staging (pTNM)\n\nPrimary tumor (pT):\tpT1a\n\nRegional lymph nodes (pN):\tpNX (Not assessed)\n\nPelvic lymph nodes:\tNo pelvic lymph nodes evaluated\n\nPara-aortic lymph nodes:\tNo para-aortic lymph nodes evaluated\n\nDistant metastasis (pM):\tNot assessed\r\nGROSS:\r\nContainer label: \"Uterus and cervix, tubes and ovaries\"\n\nSpecimen includes: Uterus with cervix, bivalved, with attached bilateral adnexa (inked anterior-orange, posterior-black)\n\nFixation: Received fresh for intraoperative consultation\n\nWeight: 78 g\n\nDimensions (uterus and cervix): 7.2 x 4.9 x 2.9 cm\n\nSerosal lesion(s): None\n\nDimensions (ectocervix): 3 x 2.8 cm\n\nEctocervical lesion: None\n\nEndocervical canal: 1.5 cm in length\n\nEndocervical lesion: None\n\nEndometrial thickness: 0.3 cm\n\nEndometrial lesion: Tumor site: Anterior\n\nTumor configuration: Ill-defined, polypoid, nodular area\n\nTumor size: 1.5 x 1.5 x 0.2 cm\n\nExtension to lower uterine segment/cervix: None\n\nDepth of myometrial invasion: None identified grossly\n\nGross lesion entirely submitted: yes\n\nMyometrial thickness: 1.7 cm\n\nMyometrial lesion(s): Single, well-circumscribed, whorled pink-tan nodule in posterior lower uterine segment, 0.3 cm in greatest dimension\n\nLeft ovary: 3.7 x 1.5 x 1.9 cm\n\n  Serosal surface: Unremarkable\n\n  Cut surfaces: Unremarkable\n\nLeft fallopian tube: 5.5 cm length, 0.5 cm diameter\n\n  Lesion: Paratubal cyst measuring 1.8 cm in greatest dimension\n\nRight ovary: 3.3 x 2.5 x 1.6 cm\n\n  Serosal surface: Unremarkable\n\n  Cut surfaces: Unremarkable\n\nRight fallopian tube: 4.0 cm length, 0.6 cm diameter\n\n  Lesion: None\n\n\n\nCassette summary: Representatively submitted:\n\nAFS-endometrial nodular area (full thickness, deepest possible invasion) \n\nA2-anterior ectoendocervix\n\nA3 anterior lower uterine segment\n\nA4-A9-remaining anterior endometrium (entirely submitted)\n\nA10-posterior ectoendocervix\n\nA11-posterior lower uterine segment with 0.3 cm pink-tan nodule\n\nA12-A13-representative posterior endomyometrium\n\nA14-grossly normal left ovary and fallopian tube\n\nA15-grossly normal right ovary and fallopian tube\n\nA16-left fimbria\n\nA17-right fimbria\n\nA18-paratubal cyst wall (representative)\n\nA19-21-additional left fimbria\n\n\n\n\n\nINTRAOPERATIVE FROZEN CONSULTATION REPORT: \n\nA)\tUterus and cervix, bilateral tubes and ovaries, total abdominal hysterectomy:\n\n-Endometrium with focal hyperplasia; no evidence of myometrial invasion by tumor (AFS). (RR)\r\nMICROSCOPIC:\r\nMicroscopic examination was performed. See diagnosis.\r\n\r\nPathologist: Pathologist2 MD, Fake S  Report Date: 08/02/2015\r\n")
    expect(pathology_case.abstractor_abstractions.size).to eq(2)
  end

  it 'imports and abstracts pathology cases from HL7', focus: false do
    expect(PathologyCase.count).to eq(0)
    batch_import = FactoryGirl.create(:hl7_batch_import)
    batch_import.import
    expect(PathologyCase.count).to eq(2)
    pathology_case = PathologyCase.where(accession_number: 'GHS1506001').first
    expect(pathology_case).to_not be_nil
    expect(pathology_case.collection_date).to eq(Date.parse('09/01/2015'))
    expect(pathology_case.patient_last_name).to eq('TEST1')
    expect(pathology_case.patient_first_name).to eq('POWERPATH')
    expect(pathology_case.mrn).to eq('011111111')
    expect(pathology_case.ssn).to eq('111111111')
    expect(pathology_case.birth_date).to eq(Date.parse('01/01/1981'))
    expect(pathology_case.street1).to eq('111 MAIN STREET')
    expect(pathology_case.street2).to eq('APT 1')
    expect(pathology_case.city).to eq('ANYWHERE1')
    expect(pathology_case.state).to eq('IL')
    expect(pathology_case.zip_code).to eq('11111')
    expect(pathology_case.country).to eq('US')
    expect(pathology_case.home_phone).to eq('(111)111-1111')
    expect(pathology_case.sex).to eq('M')
    expect(pathology_case.race).to eq('W')
    expect(pathology_case.attending).to eq('DOCTOR JR MD, FAKE')
    expect(pathology_case.surgeon).to eq('DOCTOR JR MD, FAKE')
    expect(pathology_case.note).to eq("CASE: GHS-15-06001 \r\nPATIENT: POWERPATH TEST1 \r\nPre-Op Diagnosis:   Two lipomas, Right upper arm \r\nPost-Op Diagnosis:  None Given \r\nClinical History:   None Given \r\n \r\n \r\n \r\n \r\n \r\nFINAL DIAGNOSIS: \r\n \r\nA) Right upper arm biceps mass, excision: \r\n- Portions of mature adipose tissue (lipoma). \r\nB) Right upper arm triceps mass, excision: \r\n- Portions of mature adipose tissue (lipoma). \r\n \r\nGROSS: \r\n \r\nA) The specimen is received in formalin labeled with the patient's \r\nname and designated \"right upper arm biceps\" and consists of 2 \r\nyellow-tan portions of fibrofatty tissue which measure 2.0 x 1.5 x \r\n1.3 and 1.1 x 0.4 x 0.3 cm. The larger portion is encapsulated and \r\nis inked.  The larger portion is serially sectioned. On section, the \r\ncut surface is yellow tan and homogenous. Representative sections \r\nare submitted in a single cassette. \r\nB) The specimen is received in formalin labeled with the patient's \r\nname and designated \"right upper arm triceps\" and consists of 2 \r\nyellow-tan portions of fibrofatty tissue which measure 3.0 x 2.8 x \r\n1.3 and 0.8 x 0.7 x 0.4 cm. The larger portion is encapsulated and \r\nis inked.  The larger portion is serially sectioned. On section, the \r\ncut surface is yellow tan and homogenous. Representative sections \r\nare submitted in 2 cassettes. \r\nDV 9/1/2015 \r\n \r\nMICROSCOPIC: \r\n \r\nMicroscopic examination was performed. See diagnosis. \r\n \r\n \r\nThe electronic signature indicates that the named Attending \r\nPathologist has evaluated the specimen referred to in the signed \r\nsection of the report and formulated the diagnosis therein. \r\n \r\n \r\n \r\nWayne H Wirtz, MD \r\nPathologist \r\nElectronically signed 9/3/2015 8:21:58AM \r\n \r\n \r\n")
    expect(pathology_case.abstractor_abstractions.size).to eq(2)

    pathology_case = PathologyCase.where(accession_number: 'GHS1506002').first
    expect(pathology_case).to_not be_nil
    expect(pathology_case.collection_date).to eq(Date.parse('09/02/2015'))
    expect(pathology_case.patient_last_name).to eq('TEST2')
    expect(pathology_case.patient_first_name).to eq('POWERPATH2')
    expect(pathology_case.mrn).to eq('022222222')
    expect(pathology_case.ssn).to eq('222222222')
    expect(pathology_case.birth_date).to eq(Date.parse('01/02/1981'))
    expect(pathology_case.street1).to eq('222 MAIN STREET')
    expect(pathology_case.street2).to eq('APT 2')
    expect(pathology_case.city).to eq('ANYWHERE2')
    expect(pathology_case.state).to eq('IL')
    expect(pathology_case.zip_code).to eq('22222')
    expect(pathology_case.country).to eq('US')
    expect(pathology_case.home_phone).to eq('(222)222-2222')
    expect(pathology_case.sex).to eq('M')
    expect(pathology_case.race).to eq('W')
    expect(pathology_case.attending).to eq('DOCTOR2 JR MD, FAKE')
    expect(pathology_case.surgeon).to eq('DOCTOR2 JR MD, FAKE')
    expect(pathology_case.note).to eq("CASE: GHS-15-06002 \r\nPATIENT: POWERPATH2 TEST2 \r\nPre-Op Diagnosis:   Two lipomas, Right upper arm \r\nPost-Op Diagnosis:  None Given \r\nClinical History:   None Given \r\n \r\n \r\n \r\n \r\n \r\nFINAL DIAGNOSIS: \r\n \r\nA) Right upper arm biceps mass, excision: \r\n- Portions of mature adipose tissue (lipoma). \r\nB) Right upper arm triceps mass, excision: \r\n- Portions of mature adipose tissue (lipoma). \r\n \r\nGROSS: \r\n \r\nA) The specimen is received in formalin labeled with the patient's \r\nname and designated \"right upper arm biceps\" and consists of 2 \r\nyellow-tan portions of fibrofatty tissue which measure 2.0 x 1.5 x \r\n1.3 and 1.1 x 0.4 x 0.3 cm. The larger portion is encapsulated and \r\nis inked.  The larger portion is serially sectioned. On section, the \r\ncut surface is yellow tan and homogenous. Representative sections \r\nare submitted in a single cassette. \r\nB) The specimen is received in formalin labeled with the patient's \r\nname and designated \"right upper arm triceps\" and consists of 2 \r\nyellow-tan portions of fibrofatty tissue which measure 3.0 x 2.8 x \r\n1.3 and 0.8 x 0.7 x 0.4 cm. The larger portion is encapsulated and \r\nis inked.  The larger portion is serially sectioned. On section, the \r\ncut surface is yellow tan and homogenous. Representative sections \r\nare submitted in 2 cassettes. \r\nDV 9/1/2015 \r\n \r\nMICROSCOPIC: \r\n \r\nMicroscopic examination was performed. See diagnosis. \r\n \r\n \r\nThe electronic signature indicates that the named Attending \r\nPathologist has evaluated the specimen referred to in the signed \r\nsection of the report and formulated the diagnosis therein. \r\n \r\n \r\n \r\nWayne H Wirtz, MD \r\nPathologist \r\nElectronically signed 9/3/2015 8:21:58AM \r\n \r\n \r\n")
    expect(pathology_case.abstractor_abstractions.size).to eq(2)
  end
end