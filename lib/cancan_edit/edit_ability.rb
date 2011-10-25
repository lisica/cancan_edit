module CanCan
  
  module EditAbility
    
    def can_edit?(field, subject, *extra_args)
      match = relevant_edit_rules_for_match(field, subject).detect do |rule|
        rule.matches_conditions?(field, subject, extra_args)
      end
      match ? match.base_behavior : false
    end

    def cannot_edit?(*args)
      !can_edit?(*args)
    end
      
    def can_edit(field = nil, subject = nil, conditions = nil, &block)
      edit_rules << EditRule.new(true, field, subject, conditions, block)
    end
    
    def cannot_edit(field = nil, subject = nil, conditions = nil, &block)
      edit_rules << EditRule.new(false, field, subject, conditions, block)
    end
    
    def has_block?(field, subject)
      relevant_rules(field, subject).any?(&:only_block?)
    end

    def has_raw_sql?(field, subject)
      relevant_rules(field, subject).any?(&:only_raw_sql?)
    end

  private
    
    def edit_rules
      @edit_rules ||= []
    end
    
    def relevant_edit_rules(field, subject)
      edit_rules.reverse.select do |edit_rule|     
        edit_rule.expanded_fields = edit_rule.fields
        edit_rule.relevant? field, subject
      end
    end
    
    
    def relevant_edit_rules_for_match(field, subject)
      relevant_edit_rules(field, subject).each do |rule|
        if rule.only_raw_sql?
          raise Error, "The can? and cannot? call cannot be used with a raw sql 'can' definition. The checking code cannot be determined for #{field.inspect} #{subject.inspect}"
        end
      end
    end

  end
end
