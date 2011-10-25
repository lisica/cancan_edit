module CanCan
  class EditRule 
    attr_reader :base_behavior, :subjects, :fields, :conditions
    attr_writer :expanded_fields

    def initialize(base_behavior, field, subject, conditions, block)
      raise Error, "You are not able to supply a block with a hash of conditions in #{field} #{subject} ability. Use either one." if conditions.kind_of?(Hash) && !block.nil?
      @match_all = field.nil? && subject.nil?
      @base_behavior = base_behavior
      @fields = [field].flatten
      @subjects = [subject].flatten
      @conditions = conditions || {}
      @block = block
    end

    def relevant?(field, subject)
      subject = subject.values.first if subject.class == Hash
      @match_all || (matches_field?(field) && matches_subject?(subject))
    end
    
    def matches_conditions?(field, subject, extra_args)
      if @match_all
        call_block_with_all(field, subject, extra_args)
      elsif @block && !subject_class?(subject)
        @block.call(subject, *extra_args)
      elsif @conditions.kind_of?(Hash) && subject.class == Hash
        nested_subject_matches_conditions?(subject)
      elsif @conditions.kind_of?(Hash) && !subject_class?(subject)
        matches_conditions_hash?(subject)
      else
        @conditions.empty? ? true : @base_behavior
      end
    end
    
    def only_block?
      conditions_empty? && !@block.nil?
    end
    
    def only_raw_sql?
      @block.nil? && !conditions_empty? && !@conditions.kind_of?(Hash)
    end

    def conditions_empty?
      @conditions == {} || @conditions.nil?
    end
  
  private 
  
    def subject_class?(subject)
      klass = (subject.kind_of?(Hash) ? subject.values.first : subject).class
      klass == Class || klass == Module
    end
  
    def matches_field?(field)
      @expanded_fields.include?(:manage) || @expanded_fields.include?(field)
    end
  
    def matches_subject?(subject)
      @subjects.include?(:all) || @subjects.include?(subject) || matches_subject_class?(subject)
    end
  
    def matches_subject_class?(subject)
      @subjects.any? { |sub| sub.kind_of?(Module) && (subject.kind_of?(sub) || subject.class.to_s == sub.to_s || subject.kind_of?(Module) && subject.ancestors.include?(sub)) }
    end
    
    def matches_conditions_hash?(subject, conditions = @conditions)
      if conditions.empty?
        true
      else
        if model_adapter(subject).override_conditions_hash_matching? subject, conditions
          model_adapter(subject).matches_conditions_hash? subject, conditions
        else
          conditions.all? do |name, value|
            if model_adapter(subject).override_condition_matching? subject, name, value
              model_adapter(subject).matches_condition? subject, name, value
            else
              attribute = subject.send(name)
              if value.kind_of?(Hash)
                if attribute.kind_of? Array
                  attribute.any? { |element| matches_conditions_hash? element, value }
                else
                  !attribute.nil? && matches_conditions_hash?(attribute, value)
                end
              elsif value.kind_of?(Array) || value.kind_of?(Range)
                value.include? attribute
              else
                attribute == value
              end
            end
          end
        end
      end
    end

    def nested_subject_matches_conditions?(subject_hash)
      parent, child = subject_hash.shift
      matches_conditions_hash?(parent, @conditions[parent.class.name.downcase.to_sym] || {})
    end

    def call_block_with_all(field, subject, extra_args)
      if subject.class == Class
        @block.call(field, subject, nil, *extra_args)
      else
        @block.call(field, subject.class, subject, *extra_args)
      end
    end
    
    def model_adapter(subject)
      ModelAdapters::AbstractAdapter.adapter_class(subject_class?(subject) ? subject : subject.class)
    end
  end
end

