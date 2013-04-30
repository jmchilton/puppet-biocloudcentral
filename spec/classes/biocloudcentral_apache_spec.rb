require 'spec_helper'

describe 'biocloudcentral::apache' do

  let :pre_condition do
    'include apache'
  end

  context "on Ubuntu" do
    let :facts do
      {
        :osfamily               => 'debian',
        :operatingsystemrelease => 'percise',
      }
    end

    describe 'with defaults' do

      it { should contain_class('apache') }

    end

  end

end