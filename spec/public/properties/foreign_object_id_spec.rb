require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe DataMapper::Mongo::Property::ForeignObjectId do
  before(:all) do
    class User
      include DataMapper::Mongo::Resource

      property :id,       ObjectId
      property :group_id, ForeignObjectId
    end

    @property_class = DataMapper::Mongo::Property::ForeignObjectId
    @property       = User.properties[:group_id]
  end

  it 'should set default field to property name' do
    @property.field.should == 'group_id'
  end

  it 'should not default to be a key' do
    @property.key?.should be_false
  end

  it_should_behave_like 'An ObjectId Type'
end