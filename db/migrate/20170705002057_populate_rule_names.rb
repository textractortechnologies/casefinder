class PopulateRuleNames < ActiveRecord::Migration
  def change
    Abstractor::AbstractorRule.all.each do |rule|
      if m = /rule\s+"(.+)"$/.match(rule.rule)
        rule.name = m[1]
        rule.save!
      end
    end
  end
end
