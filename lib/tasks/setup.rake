require 'csv'
require './lib/case_finder/setup/'
namespace :setup do
  desc "Rules"
  task(rules: :environment) do  |t, args|
    abstractor_abstraction_schema_has_cancer_histology = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_histology').first
    abstractor_abstraction_schema_has_cancer_site = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_site').first
    abstractor_subject_abstraction_schema_has_cancer_histology = Abstractor::AbstractorSubject.where(subject_type: PathologyCase.to_s, abstractor_abstraction_schema_id: abstractor_abstraction_schema_has_cancer_histology.id).first
    abstractor_subject_abstraction_schema_has_cancer_site = Abstractor::AbstractorSubject.where(subject_type: PathologyCase.to_s, abstractor_abstraction_schema_id: abstractor_abstraction_schema_has_cancer_site.id).first

    Abstractor::AbstractorRule.destroy_all
    Abstractor::AbstractorRuleAbstractorSubject.destroy_all

    #Rule 0 Deb/Addie:Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION: Rule 0
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: one of meningioma, nos (9530/0), meningiomatosis, nos (9530/1), ...
    // and this site does not yet exist: meninges, nos (c70.9)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then add site: meninges, nos (c70.9)
    // ---------------------------------------------------------------------------------------------------------------------
    rule "0: Add Site C70.9"
    when
       $hist : Histology(code in ("9530/0","9530/1","9531/0","9532/0","9533/0","9534/0","9537/0","9538/1","9539/1"))
       and forall (Site(code != "C70.9"))
    then
        suggestions.addNewSite("meninges, nos (c70.9)", $hist.suggestion.getSuggestion_sources());
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!


    #Rule 1 Deb/Addie:Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // Rule Description:
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology code has a */0 or */1 extension, and there are no brain-related sites,
    // ---------------------------------------------------------------------------------------------------------------------
    // Then delete the histology
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Remove */0 and */1 Histology codes"
    when
       $hist : Histology(codeMatches(".+/[0|1]"))
       and exists Site()
       and forall (Site (code not in ("C70.0","C70.1","C70.9","C71.0","C71.1","C71.2","C71.3","C71.4",
                                      "C71.5","C71.6","C71.7","C71.8","C71.9","C72.0","C72.1","C72.2",
                                      "C72.3","C72.4","C72.5","C72.8","C72.9","C75.1","C75.2","C75.3")))
    then
        suggestions.remove($hist.suggestion);
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 2 Deb/Addie:Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology is one of a particular set of histologies, and the only sites are skin-related,
    // ---------------------------------------------------------------------------------------------------------------------
    // Then delete the histology
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Remove Histology codes when Skin Site"
    when
       $hist : Histology(code in ("8000/3","8000/6","8000/9","8001/3","8002/3","8003/3","8004/3","8005/3",
                                  "8010/2","8010/3","8010/6","8010/9","8011/3","8012/3","8013/3","8014/3",
                                  "8015/3","8020/3","8021/3","8022/3","8030/3","8031/3","8032/3","8033/3",
                                  "8034/3","8035/3","8041/3","8042/3","8043/3","8044/3","8045/3","8046/3",
                                  "8050/2","8050/3","8051/3","8052/2","8052/3","8070/2","8070/3","8070/6",
                                  "8071/3","8072/3","8073/3","8074/3","8075/3","8076/2","8076/3",
                                  "8078/3","8080/2","8081/2","8082/3","8083/3","8084/3","8090/1","8090/3",
                                  "8091/3","8092/3","8093/3","8094/3","8095/3","8097/3","8098/3","8102/3",
                                  "8110/0","8110/3"))
       and exists(Site())
       and forall (Site (code in ("C44.0","C44.1","C44.2","C44.3","C44.4","C44.5","C44.6","C44.7","C44.8","C44.9")))
    then
        suggestions.remove($hist.suggestion);
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 3 Deb/Addie:Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology is squamous intraepithelial neoplasia, high grade (8077/2), ...
    // and all sites are skin or cervix
    // ---------------------------------------------------------------------------------------------------------------------
    // Then delete the histology
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Remove 8077/2"
    when
        $hist : Histology(suggestion.value in
                                    ("squamous intraepithelial neoplasia, high grade (8077/2)",
                                     "squamous intraepithelial neoplasia, grade iii (8077/2)",
                                     "cervical intraepithelial neoplasia, grade iii (8077/2)",
                                     "cin iii with severe dysplasia (8077/2)"))
        and exists(Site())
        and forall (Site(code in ("C44.0","C44.1","C44.2","C44.3","C44.4","C44.5","C44.6","C44.7","C44.8","C44.9",
                                 "C53.0", "C53.1", "C53.8", "C53.9")))
    then
        suggestions.remove($hist.suggestion);
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 4 Deb/Addie: To verify if always replacing with with "pancreatic endocrine tumor, malignant  (8150/3)" is OK.
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology is pancreatic endocrine tumor, benign  (8150/0) or pancreatic endocrine tumor, nos (8150/1)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Replace with 8150/3"
    when
       $hist : Histology(code in ("8150/0", "8150/1"))
    then
        $hist.suggestion.setValue("pancreatic endocrine tumor, malignant  (8150/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 5 Deb/Addie:Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology is: insulinoma, nos (8151/0)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Replace with 8151/3"
    when
       $hist : Histology(suggestion.value == "insulinoma, nos (8151/0)")
    then
        $hist.suggestion.setValue("insulinoma, malignant (8151/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 6 Deb/Addie: To verify if always replacing with with "enteroglucagonoma, malignant (8152/3)" is OK.
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology is: enteroglucagonoma, nos (8152/1), ...
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Replace with 8152/3"
    when
       $hist : Histology(code == "8152/1")
    then
        $hist.suggestion.setValue("enteroglucagonoma, malignant (8152/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 7 Deb/Addie: To verify if always replacing with with "gastrinoma, malignant (8153/3)" is OK.
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology is: gastrinoma, nos (8153/1)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Replace with 8153/3"
    when
       $hist : Histology(code == "8153/1")
    then
        $hist.suggestion.setValue("gastrinoma, malignant (8153/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 8 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology is: vipoma, nos (8155/1)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Replace with 8155/3"
    when
       $hist : Histology(code == "8155/1")
    then
        $hist.suggestion.setValue("vipoma, malignant (8155/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 9 Deb/Addie: To verify if always replacing with with "somatostatinoma, malignant (8156/3)" is OK.
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology is: somatostatinoma, nos (8156/1)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Replace with 8156/3"
    when
       $hist : Histology(code == "8156/1")
    then
        $hist.suggestion.setValue("somatostatinoma, malignant (8156/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 10 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When a histology is: teratoma, benign (9080/0)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Replace with 9080/3"
    when
       $hist : Histology(code == "9080/0")
    then
        $hist.suggestion.setValue("teratoma, malignant, nos (9080/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 11 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: acinar cell carcinoma (8550/3)
    // and all sites are: prostate gland (c61.9)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: adenocarcinoma, nos (8140/3)
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Replace with 8140/3"
    when
       $hist : Histology(code in ("8550/3"))
       and exists(Site())
       and forall(Site(code == "C61.9"))
    then
        $hist.suggestion.setValue("adenocarcinoma, nos (8140/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 12 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION: Rule 12
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: acinar cell carcinoma (8550/3)
    // and one of the sites is: prostate gland (c61.9)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then add the histology with: adenocarcinoma, nos (8140/3)
    // ---------------------------------------------------------------------------------------------------------------------
    rule "12: Add copy with 8140/3"
    when
       $hist : Histology(code in ("8550/3"))
       and exists(Site(code != "C61.9"))
       and exists(Site(code == "C61.9"))
    then
       suggestions.addNewHist("adenocarcinoma, nos (8140/3)", $hist.suggestion.getSuggestion_sources());
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 13 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: metastatic (8000/6)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "replace 8000/6"
    when
        $hist : Histology(code == "8000/6")
    then
        $hist.suggestion.setValue("neoplasm, malignant (8000/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 14 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: carcinoma, metastatic, nos (8010/6)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "replace 8010/6"
    when
        $hist : Histology(code == "8010/6")
    then
        $hist.suggestion.setValue("carcinoma, nos (8010/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 15 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: squamous cell carcinoma, metastatic, nos (8070/6)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "replace 8070/6"
    when
        $hist : Histology(code == "8070/6")
    then
        $hist.suggestion.setValue("squamous cell carcinoma, nos (8070/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 16 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: adenocarcinoma, metastatic, nos (8140/6)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "replace 8140/6"
    when
        $hist : Histology(code == "8140/6")
    then
        $hist.suggestion.setValue("adenocarcinoma, nos (8140/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 17 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: pseudomyxoma peritonei (8480/6)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "replace 8480/6"
    when
        $hist : Histology(code == "8480/6")
    then
        $hist.suggestion.setValue("mucinous adenocarcinoma (8480/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 18 Deb/Addie: Yes
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: slvl (9689/6)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: */3
    // ---------------------------------------------------------------------------------------------------------------------
    rule "replace 9689/6"
    when
        $hist : Histology(code == "9689/6")
    then
        $hist.suggestion.setValue("splenic marginal zone lymphoma (9689/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 19 Deb/Addie: Wrong! Replace "pancreatic endocrine tumor, malignant  (8150/3)" with "papillary carcinoma of thyroid (8260/3)".
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: papillary carcinoma, nos (8050/3)
    // and all sites are: thyroid gland (c73.9)
    // ---------------------------------------------------------------------------------------------------------------------
    // Then replace the histology with: papillary carcinoma of thyroid (8260/3)
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Replace with Histology 8150/3"
    when
       $hist : Histology(code == "8050/3")
       and exists(Site())
       and forall (Site(code == "C73.9"))
    then
        $hist.suggestion.setValue("papillary carcinoma of thyroid (8260/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 20 Wrong! Replace "pancreatic endocrine tumor, malignant  (8150/3)" with "papillary carcinoma of thyroid (8260/3)".
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: papillary carcinoma, nos (8050/3)
    // and one site is: thyroid gland (c73.9)
    // and another site exists that is something else
    // ---------------------------------------------------------------------------------------------------------------------
    // Then add a new histology with: papillary carcinoma of thyroid (8260/3)
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Add Histology 8150/3"
    when
       $hist : Histology(code == "8050/3")
       and exists(Site(code != "C73.9"))
       and exists(Site(code == "C73.9"))
    then
       suggestions.addCopy($hist.suggestion, "papillary carcinoma of thyroid (8260/3)");
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 21
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION: Rule 21
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: one of leukemias
    // ---------------------------------------------------------------------------------------------------------------------
    // Then add site: bone marrow (c42.1)
    // ---------------------------------------------------------------------------------------------------------------------
    rule "21: Add Site c42.1"
    when
      forall (Site(code != "C42.1"))
      $hist : Histology(code in ("9742/3", "9800/3", "9801/3", "9806/3", "9807/3", "9808/3", "9809/3", "9811/3",
      "9812/3", "9813/3", "9814/3", "9815/3", "9816/3", "9817/3", "9818/3", "9820/3",
      "9823/3", "9826/3", "9827/3", "9831/3", "9832/3", "9833/1", "9833/3", "9834/3",
      "9837/3", "9840/3", "9860/3", "9861/3", "9863/3", "9865/3", "9866/3", "9867/3",
      "9869/3", "9870/3", "9871/3", "9872/3", "9873/3", "9874/3", "9875/3", "9876/3",
      "9880/3", "9891/3", "9895/3", "9896/3", "9897/3", "9898/1", "9898/3", "9910/3",
      "9911/3", "9940/3", "9945/3", "9946/3", "9948/3", "9950/3", "9961/3", "9962/3",
      "9963/3", "9964/3", "9965/3", "9966/3", "9967/3", "9971/1", "9971/3", "9975/3",
      "9980/3", "9982/3", "9983/3", "9985/3", "9986/3", "9989/3"))
    then
      suggestions.addNewSite("bone marrow (c42.1)", $hist.suggestion.getSuggestion_sources());
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 22
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION: Rule 22
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: 9761/3
    // ---------------------------------------------------------------------------------------------------------------------
    // Then add site: blood (c42.0)
    // ---------------------------------------------------------------------------------------------------------------------
    rule "22: Add Site c42.0"
    when
      forall (Site(code != "C42.0"))
      $hist : Histology(code in ("9761/3"))
    then
      suggestions.addNewSite("blood (c42.0)", $hist.suggestion.getSuggestion_sources());
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    # #Rule 23
    # abstractor_rule = Abstractor::AbstractorRule.new
    # abstractor_rule.rule = <<-HEREDOC
    # // ---------------------------------------------------------------------------------------------------------------------
    # // RULE DESCRIPTION: Rule 23
    # // ---------------------------------------------------------------------------------------------------------------------
    # // When site is: C42.0
    # // ---------------------------------------------------------------------------------------------------------------------
    # // Then add histology: neoplasm, malignant (8000/3)
    # // ---------------------------------------------------------------------------------------------------------------------
    # rule "23: Add neoplasm, malignant (8000/3)"
    # when
    #   $site: (Site(code == "C42.0"))
    # then
    #   suggestions.addNewHist("neoplasm, malignant (8000/3)", $site.suggestion.getSuggestion_sources());
    # end
    # HEREDOC
    #
    # abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    # abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    # abstractor_rule.save!

    #Rule 24
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION: Rule 24
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: lymphoma
    // ---------------------------------------------------------------------------------------------------------------------
    // Then add site: lymph node, nos (c77.9)
    // ---------------------------------------------------------------------------------------------------------------------
    rule "23: Add lymph node, nos (c77.9) "
    when
      $hist : Histology(code in ("9650/3", "9651/3", "9652/3", "9653/3",
      "9655/3", "9659/3", "9663/3", "9823/3", "9727/3", "9811/3",
      "9812/3", "9813/3", "9814/3", "9815/3", "9816/3", "9817/3",
      "9818/3", "9827/3", "9837/3", "9590/3", "9591/3", "9670/3",
      "9671/3", "9673/3", "9678/3", "9679/3", "9684/3", "9687/3",
      "9688/3", "9689/3", "9689/6", "9690/3", "9691/3", "9695/3",
      "9698/3", "9699/3", "9700/3", "9701/3", "9702/3", "9705/3",
      "9708/3", "9709/3", "9712/3", "9714/3", "9716/3", "9717/3",
      "9718/3", "9719/3", "9724/3", "9725/3", "9726/3", "9728/3",
      "9729/3", "9735/3", "9737/3", "9738/3", "9596/3", "9680/3",
      "9597/3", "9734/3", "9751/3", "9755/3", "9756/3", "9757/3",
      "9758/3", "9759/3", "9930/3"))
    then
      suggestions.addNewSite("lymph node, nos (c77.9)", $hist.suggestion.getSuggestion_sources());
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 25
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION: Rule 25
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: skin cancer
    // and sites are all skin sites except one
    // ---------------------------------------------------------------------------------------------------------------------
    // Then remove skin histology
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Remove Histology codes when skin site and just one other site"
    when
      $hist : Histology(code in ("8000/3","8000/6","8000/9","8001/3","8002/3","8003/3","8004/3","8005/3",
                                 "8010/2","8010/3","8010/6","8010/9","8011/3","8012/3","8013/3","8014/3",
                                 "8015/3","8020/3","8021/3","8022/3","8030/3","8031/3","8032/3","8033/3",
                                 "8034/3","8035/3","8041/3","8042/3","8043/3","8044/3","8045/3","8046/3",
                                 "8050/2","8050/3","8051/3","8052/2","8052/3","8070/2","8070/3","8070/6",
                                 "8071/3","8072/3","8073/3","8074/3","8075/3","8076/2","8076/3",
                                 "8078/3","8080/2","8081/2","8082/3","8083/3","8084/3","8090/1","8090/3",
                                 "8091/3","8092/3","8093/3","8094/3","8095/3","8097/3","8098/3","8102/3",
                                 "8110/0","8110/3"))
       $site1 : Site()
       $site2 : Site(code in ("C44.0","C44.1","C44.2","C44.3","C44.4",
                              "C44.5","C44.6","C44.7","C44.8","C44.9",
                              "C53.0", "C53.1", "C53.8", "C53.9")) // skin sites
       and forall(Site(code == $site1.code || code in ("C44.0","C44.1","C44.2","C44.3","C44.4",
                                                       "C44.5","C44.6","C44.7","C44.8","C44.9",
                                                       "C53.0", "C53.1", "C53.8", "C53.9"))) // skin sites
    then
      suggestions.remove($hist.suggestion);
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 26
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION: Rule 26
    // ---------------------------------------------------------------------------------------------------------------------
    // When histology is: melanoma
    // ---------------------------------------------------------------------------------------------------------------------
    // Then add site: skin, nos (c44.9)
    // ---------------------------------------------------------------------------------------------------------------------
    rule "26: Add skin, nos (c44.9)"
    when
      $hist : Histology(code in ("8720/0","8720/2","8720/3","8721/3","8722/0","8722/3",
                                 "8723/0","8723/3","8725/0","8726/0","8727/0","8728/0","8728/1",
                                 "8728/3","8730/0","8730/3","8740/0","8740/3","8741/2","8741/3",
                                 "8742/2","8742/3","8743/3","8744/3","8745/3","8746/3","8750/0",
                                 "8760/0","8761/0","8761/1","8761/3","8762/1","8770/0","8770/3",
                                 "8771/0","8771/3","8772/0","8772/3","8773/3","8774/3","8780/0",
                                 "8780/3","8790/0"))
    then
      suggestions.addNewSite("skin, nos (c44.9)", $hist.suggestion.getSuggestion_sources());
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!

    #Rule 99
    abstractor_rule = Abstractor::AbstractorRule.new
    abstractor_rule.rule = <<-HEREDOC
    // ---------------------------------------------------------------------------------------------------------------------
    // RULE DESCRIPTION
    // ---------------------------------------------------------------------------------------------------------------------
    // When no sites are suggested
    // ---------------------------------------------------------------------------------------------------------------------
    // Then add a new site with: C80.9
    // ---------------------------------------------------------------------------------------------------------------------
    rule "Rule 99: Add Site C80.9"
    when
      forall (Site(suggestion.unknown == 1))
    then
      Collection<SuggestionSource> suggestion_sources;
      suggestion_sources = new ArrayList<>();
      SuggestionSource source = new SuggestionSource();
      source.setMatch_value("");
      source.setSentence_match_value("");
      suggestion_sources.add(source);
      suggestions.addNewSite("unknown primary site (c80.9)", suggestion_sources);
    end
    HEREDOC

    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_histology.id)
    abstractor_rule.abstractor_rule_abstractor_subjects.build(abstractor_subject_id: abstractor_subject_abstraction_schema_has_cancer_site.id)
    abstractor_rule.save!
  end

  desc "Abstractor schemas new"
  task(abstractor_schemas: :environment) do  |t, args|
    source_type_custom_nlp_suggestion = Abstractor::AbstractorAbstractionSourceType.where(name: 'custom nlp suggestion').first
    CaseFinder::Setup.setup_abstractor_schemas(source_type_custom_nlp_suggestion)
  end

  desc "Abstractor schemas"
  task(abstractor_schemas_legacy: :environment) do  |t, args|
    list_object_type = Abstractor::AbstractorObjectType.where(value: 'list').first
    boolean_object_type = Abstractor::AbstractorObjectType.where(value: 'boolean').first
    string_object_type = Abstractor::AbstractorObjectType.where(value: 'string').first
    number_object_type = Abstractor::AbstractorObjectType.where(value: 'number').first
    radio_button_list_object_type = Abstractor::AbstractorObjectType.where(value: 'radio button list').first
    dynamic_list_object_type = Abstractor::AbstractorObjectType.where(value: 'dynamic list').first
    name_value_rule = Abstractor::AbstractorRuleType.where(name: 'name/value').first
    value_rule = Abstractor::AbstractorRuleType.where(name: 'value').first
    unknown_rule = Abstractor::AbstractorRuleType.where(name: 'unknown').first
    source_type_nlp_suggestion = Abstractor::AbstractorAbstractionSourceType.where(name: 'nlp suggestion').first
    source_type_custom_nlp_suggestion = Abstractor::AbstractorAbstractionSourceType.where(name: 'custom nlp suggestion').first
    indirect_source_type = Abstractor::AbstractorAbstractionSourceType.where(name: 'indirect').first

    primary_cancer_group  = Abstractor::AbstractorSubjectGroup.where(name: 'Primary Cancer', enable_workflow_status: true, workflow_status_submit: 'Submit to METRIQ',  workflow_status_pend: 'Remove from METRIQ').first_or_create
    abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(
      predicate: 'has_cancer_histology',
      display_name: 'Histology',
      abstractor_object_type: list_object_type,
      preferred_name: 'cancer histology').first_or_create

    histologies = CSV.new(File.open('lib/setup/data/ICD-O Codes Updated 1.14.15.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    histologies.each do |histology|
      if histology.to_hash['Canonical?'] == 'TRUE'
        abstractor_object_value = Abstractor::AbstractorObjectValue.where(:value => "#{histology.to_hash['Term'].downcase} (#{histology.to_hash['Code']})".downcase, vocabulary_code: histology.to_hash['Code'], vocabulary: 'ICD-O-3', vocabulary_version: '2011 Updates to ICD-O-3', properties: { type: histology.to_hash['Type'], select_for: histology.to_hash['Select for']}.to_json).first_or_create
        Abstractor::AbstractorAbstractionSchemaObjectValue.where(abstractor_abstraction_schema: abstractor_abstraction_schema, abstractor_object_value: abstractor_object_value).first_or_create
        Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => histology.to_hash['Term'].downcase).first_or_create

        normalized_values = CaseFinder::Setup.normalize(histology.to_hash['Term'].downcase)
        normalized_values.each do |normalized_value|
          if !CaseFinder::Setup.object_value_exists?(abstractor_abstraction_schema, normalized_value)
            Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => normalized_value.downcase).first_or_create
          end
        end
      else
        abstractor_object_value = Abstractor::AbstractorObjectValue.where(vocabulary_code: histology.to_hash['Code'], vocabulary: 'ICD-O-3', vocabulary_version: '2011 Updates to ICD-O-3').first
        Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => histology.to_hash['Term'].downcase).first_or_create
        normalized_values = CaseFinder::Setup.normalize(histology.to_hash['Term'].downcase)
        normalized_values.each do |normalized_value|
          if !CaseFinder::Setup.object_value_exists?(abstractor_abstraction_schema, normalized_value)
            Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => normalized_value.downcase).first_or_create
          end
        end
      end
    end

    abstractor_subject = Abstractor::AbstractorSubject.where(:subject_type => 'PathologyCase', :abstractor_abstraction_schema => abstractor_abstraction_schema).first_or_create
    # Abstractor::AbstractorAbstractionSource.where(abstractor_subject: abstractor_subject, from_method: 'note', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_nlp_suggestion).first_or_create
    Abstractor::AbstractorAbstractionSource.where(abstractor_subject: abstractor_subject, from_method: 'note', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_custom_nlp_suggestion, custom_nlp_provider: 'health_heritage_casefinder_nlp_service').first_or_create
    Abstractor::AbstractorSubjectGroupMember.where(:abstractor_subject => abstractor_subject, :abstractor_subject_group => primary_cancer_group, :display_order => 1).first_or_create

    abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(
      predicate: 'has_cancer_site',
      display_name: 'Site',
      abstractor_object_type: list_object_type,
      preferred_name: 'cancer site').first_or_create

    sites = CSV.new(File.open('lib/setup/data/icdo3_sites.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    sites.each do |site|
      abstractor_object_value = Abstractor::AbstractorObjectValue.where(:value => "#{site.to_hash['name']} (#{site.to_hash['icdo3_code']})".downcase, vocabulary_code: site.to_hash['icdo3_code'], vocabulary: 'ICD-O-3', vocabulary_version: '2011 Updates to ICD-O-3').first_or_create
      Abstractor::AbstractorAbstractionSchemaObjectValue.where(abstractor_abstraction_schema: abstractor_abstraction_schema, abstractor_object_value: abstractor_object_value).first_or_create
      Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => site.to_hash['name'].downcase).first_or_create
      site_synonyms = CSV.new(File.open('lib/setup/data/icdo3_site_synonyms.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
      site_synonyms.select { |site_synonym| site.to_hash['icdo3_code'] == site_synonym.to_hash['icdo3_code'] }.each do |site_synonym|
        Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => site_synonym.to_hash['synonym_name'].downcase).first_or_create
      end
    end

    abstractor_subject = Abstractor::AbstractorSubject.where(:subject_type => 'PathologyCase', :abstractor_abstraction_schema => abstractor_abstraction_schema).first_or_create
    # Abstractor::AbstractorAbstractionSource.where(abstractor_subject: abstractor_subject, from_method: 'note', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_nlp_suggestion).first_or_create
    Abstractor::AbstractorAbstractionSource.where(abstractor_subject: abstractor_subject, from_method: 'note', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_custom_nlp_suggestion, custom_nlp_provider: 'health_heritage_casefinder_nlp_service').first_or_create
    Abstractor::AbstractorSubjectGroupMember.where(:abstractor_subject => abstractor_subject, :abstractor_subject_group => primary_cancer_group, :display_order => 2).first_or_create
  end

  desc "To only fine grained sites"
  task(migrate_to_only_fine_grained_sites: :environment) do  |t, args|
    abstraction_schema_site = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_site').first
    sites = CSV.new(File.open('lib/setup/data/icdo3_sites.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    sites.each do |site|
      abstractor_object_value = Abstractor::AbstractorObjectValue.where(vocabulary_code: site.to_hash['icdo3_code']).first
      if site.to_hash['icdo3_code'].length == 3
        abstractor_object_value.soft_delete!
        abstractor_object_value.abstractor_object_value_variants.each do |abstractor_object_value_variant|
          abstractor_object_value_variant.soft_delete!
        end
      else
        puts 'moomin says hi'
        puts site.to_hash['name']
        normalized_values = CaseFinder::Setup.normalize(site.to_hash['name'].downcase)
        normalized_values.each do |normalized_value|
          puts 'little my says hi'
          puts normalized_value
          if !CaseFinder::Setup.object_value_exists?(abstraction_schema_site, normalized_value)
            puts 'snufkin says hi'
            puts normalized_value
            Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => normalized_value.downcase).first_or_create
          end
        end
      end
    end
  end

  desc "To more fine grained histologies"
  task(migrate_to_more_fine_grained_histologies: :environment) do  |t, args|
    abstraction_schema_histology = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_histology').first
    histologies = Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where(abstractor_abstraction_schema_object_values: { abstractor_abstraction_schema_id: abstraction_schema_histology } )
    histologies.each do |histology|
      histology.soft_delete!
      histology.abstractor_object_value_variants.each do |abstractor_object_value_variant|
        abstractor_object_value_variant.soft_delete!
      end
    end

    histologies = CSV.new(File.open('lib/setup/data/MASTER ICD-O Codes 7.20.16_modified_mgurley.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    histologies.each do |histology|
      if histology.to_hash['Curated?'].blank? || histology.to_hash['Curated?'] == 'yes'
        abstractor_object_value = Abstractor::AbstractorObjectValue.where(value: "#{histology.to_hash['Term'].downcase} (#{histology.to_hash['Code']})".downcase, vocabulary_code: histology.to_hash['Code'], vocabulary: 'ICD-O-3', vocabulary_version: '2011 Updates to ICD-O-3', properties: { type: histology.to_hash['Type'], select_for: histology.to_hash['Select for']}.to_json, deleted_at: nil).first_or_create
        Abstractor::AbstractorAbstractionSchemaObjectValue.where(abstractor_abstraction_schema: abstraction_schema_histology, abstractor_object_value: abstractor_object_value).first_or_create
        Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => histology.to_hash['Term'].downcase, deleted_at: nil).first_or_create

        normalized_values = CaseFinder::Setup.normalize(histology.to_hash['Term'].downcase)
        normalized_values.each do |normalized_value|
          Abstractor::AbstractorObjectValueVariant.where(abstractor_object_value:  abstractor_object_value, value: normalized_value.downcase, deleted_at: nil).first_or_create
        end
      end
    end
  end

  desc "Setup pathology cases"
  task(pathology_cases: :environment) do  |t, args|
    pathology_cases = YAML.load(ERB.new(File.read("lib/setup/data/pathology_cases.yml")).result)
    pathology_cases.each do |pathology_case_file|
      pathology_case = PathologyCase.where(accession_number: pathology_case_file['accession_number'], collection_date: pathology_case_file['encounter_date'], note: pathology_case_file['note'], patient_last_name: 'Baines', patient_first_name: 'Harold', mrn: '11111111', birth_date: '7/4/1976').first_or_create
      pathology_case.abstract
    end
  end

  desc "Setup users"
  task(users: :environment) do  |t, args|
    users = CSV.new(File.open('lib/setup/data/users.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    users.each do |user_from_file|
      user = User.where(email: user_from_file['email']).first_or_initialize
      user.password = user_from_file['password']
      user.save!
    end
  end

  desc "Setup roles"
  task(roles: :environment) do  |t, args|
    CaseFinder::Setup.setup_roles
  end

  desc "Compare histologies"
  task(compare_histologies: :environment) do  |t, args|
    new_guys = []
    updates = []
    # histologies = CSV.new(File.open('lib/setup/data/ICD-O Codes Updated 1.14.15_new.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    new_histologies = CSV.new(File.open('lib/setup/data/MASTER ICD-O Codes 7.20.16_modified_mgurley.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    puts 'hello moomin'
    # puts histologies.to_a.size
    # puts new_histologies.to_a.size

    matches = []
    misses = []
    replacements = []
    new_histologies.each do |new_histology|
      if new_histology['Curated?'].try(:strip) != 'replace'
        # puts new_histology['Code']
        # puts new_histology ['Term']
        match = nil
        histologies = CSV.new(File.open('lib/setup/data/ICD-O Codes Updated 1.14.15_new.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
        histologies.each do |histology|
          # puts histology['Code']
          # puts histology ['Term']
          if histology.to_hash['Curated?'].try(:strip) != 'replace' && new_histology.to_hash['Code'].try(:strip) == histology.to_hash['Code'].try(:strip)  && new_histology.to_hash['Term'].try(:strip) == histology.to_hash['Term'].try(:strip)
            match = histology
          end
        end

        if match.present?
          if match.to_hash['Curated?'].try(:strip) == 'replace'
            replacements << new_histology
          end
            matches << new_histology
        else
          misses << new_histology
        end

        if match.size > 1
          puts 'we have a problem'
          match.each do |m|
            puts m
          end
        end
      end
    end

    old_misses = []
    histologies = CSV.new(File.open('lib/setup/data/ICD-O Codes Updated 1.14.15_new.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    histologies.each do |histology|
      if histology.to_hash['Curated?'].try(:strip) != 'replace'
        new_histologies = CSV.new(File.open('lib/setup/data/MASTER ICD-O Codes 7.20.16.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
        match = []
        match = new_histologies.select do |new_histology|
          new_histology.to_hash['Curated?'].try(:strip) != 'replace' && new_histology.to_hash['Code'].try(:strip) == histology.to_hash['Code'].try(:strip)  && new_histology.to_hash['Term'].try(:strip) == histology.to_hash['Term'].try(:strip)
        end
        if match.empty?
          old_misses << histology
        end
      end
    end

    puts "How many old misses #{old_misses.size}"
    puts "How many matches: #{matches.size}"
    puts "How many misses: #{misses.size}"
    puts "How many replacements: #{replacements.size}"

    puts 'here are the misses'
    misses.each do |miss|
      puts 'begin miss'
      puts miss.to_hash['Code']
      puts miss.to_hash['Term']
      puts 'end miss'
    end

    puts 'here are the replacements'
    replacements.each do |replacement|
      puts replacement
    end
  end
end