require 'spec_helper'

describe CanCan::EditAbility do
  before(:each) do
    class Category
    end
    class Project
    end
    @ability = Object.new
    @ability.extend(CanCan::EditAbility)
  end
  
  it "should be able to edit all classes, all fields" do
    @ability.can_edit :manage, :all
    @ability.can_edit?(:field, String).should be_true
    @ability.can_edit?(:field, Category).should be_true
    @ability.can_edit?(:field, Project).should be_true
    
  end
  
  it "should be able to edit all fields of the allowed class" do
    @ability.can_edit :manage, Category
    @ability.can_edit?(:field, Category).should be_true
    @ability.can_edit?(:field, Project).should be_false
  end
  
  it "should not be able to edit fields that are not allowed" do
    @ability.can_edit :field1, Category
    @ability.can_edit?(:field1, Category).should be_true
    @ability.can_edit?(:field2, Category).should be_false
  end
  
  it "should be able to edit only allowed fields of the allowed class" do
    @ability.can_edit [:field1,:field2], Category
    @ability.can_edit?(:field1, Category).should be_true
    @ability.can_edit?(:field2, Category).should be_true
    @ability.can_edit?(:field3, Category).should be_false
  end
  
  it "should be able to edit allowed fields of allowed classes " do
    @ability.can_edit [:field1,:field2], [Category, Project]
    @ability.can_edit?(:field1, Category).should be_true
    @ability.can_edit?(:field2, Category).should be_true
    @ability.can_edit?(:field1, Project).should be_true
    @ability.can_edit?(:field2, Project).should be_true    
    @ability.can_edit?(:field3, Category).should be_false
    @ability.can_edit?(:field3, Project).should be_false
  end
  
  it "should be able to override previous" do
    @ability.can_edit [:field1,:field2], Category
    @ability.cannot_edit [:field1], Category
    @ability.cannot_edit?(:field1, Category).should be_true
  end
  
  it "should not be able to edit fields that are not allowed" do
    @ability.cannot_edit [:field1,:field2], Category
    @ability.can_edit?(:field1, Category).should be_false
    @ability.cannot_edit?(:field1, Category).should be_true
  end
  
  it "should be able to edit fields that are allowed" do
    @ability.can_edit [:field1,:field2], Category
    @ability.can_edit?(:field1, Category).should be_true
    @ability.cannot_edit?(:field1, Category).should be_false
  end
  
end
