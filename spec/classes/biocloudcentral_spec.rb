require 'spec_helper'

describe 'biocloudcentral' do
  
  describe 'with defaults' do

    it { should contain_user('biocloudcentral') }

  end

end