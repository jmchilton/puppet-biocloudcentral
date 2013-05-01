require 'spec_helper'

describe 'biocloudcentral' do
  
  describe 'with defaults' do

    it { should contain_user('biocloudcentral') }

    it { should contain_file('/usr/share/biocloudcentral').with({
      'owner'  => 'biocloudcentral',
      'ensure' => 'directory',
    }) }

    it { should contain_python__virtualenv('/usr/share/biocloudcentral/project/bin').with({
      'systempkgs' => false,
    })}

    it { should contain_exec('biocloudcentral_syncdb') }

  end

end