require 'spec_helper'

describe Ardm::Property::Serial do
  before do
    @name          = :id
    @type          = described_class
    @load_as     = Integer
    @value         = 1
    @other_value   = 2
    @invalid_value = 'foo'
  end

  it_should_behave_like 'A public Property'

  describe '.options' do
    subject { described_class.options }

    it { is_expected.to be_kind_of(Hash) }

    it { is_expected.to eql(:load_as => @load_as, :dump_as => @load_as, :coercion_method => :to_integer, :min => 1, :serial => true) }
  end
end
