require 'spec_helper'

describe 'oracle_dbfs' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "oracle_dbfs class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('oracle_dbfs::params') }
        it { should contain_class('oracle_dbfs::install').that_comes_before('oracle_dbfs::config') }
        it { should contain_class('oracle_dbfs::config') }
        it { should contain_class('oracle_dbfs::service').that_subscribes_to('oracle_dbfs::config') }

        it { should contain_service('oracle_dbfs') }
        it { should contain_package('oracle_dbfs').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'oracle_dbfs class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('oracle_dbfs') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
