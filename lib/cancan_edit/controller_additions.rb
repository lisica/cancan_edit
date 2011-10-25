module CanCan
  module ControllerAdditions
    def self.included(base)
      base.helper_method :can_edit?, :cannot_edit?
    end

    def can_edit?(*args)
      current_ability.can_edit?(*args)
    end
    
    def cannot_edit?(*args)
      current_ability.cannot_edit?(*args)
    end  
  end
end

if defined? ActionController
  ActionController::Base.class_eval do
    include CanCan::ControllerAdditions
  end
end

