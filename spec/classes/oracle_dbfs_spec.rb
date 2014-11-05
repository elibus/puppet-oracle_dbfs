require 'spec_helper'

describe 'oracle_dbfs' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      describe "oracle_dbfs class without any parameters on #{osfamily}" do
        let(:params) {{
          :user_allow_other => true,
          :ewallet          => 'ewallet content',
          :cwallet          => 'cwallet content',
          :tnsnames         => 'tnsnames content',
          :sqlnet           => 'sqlnet content',
          :mounts           => {
            '/mnt/dbfs' => {
              'conn_string' => 'dbfs@DBFS',
              'mount_point' => '/mnt/dbfs',
            },
          }
        }}
        let(:facts) {{
          :osfamily       => osfamily,
          :architecture   => 'x86_64',
          :concat_basedir => "/dne"
        }}

        it { should compile.with_all_deps }

        it { should contain_class('oracle_dbfs') }
        it { should contain_class('oracle_dbfs::params') }
        it { should contain_class('oracle_dbfs::install').that_comes_before('oracle_dbfs::config') }
        it { should contain_class('oracle_dbfs::config') }
        it { should contain_class('oracle_dbfs::service').that_subscribes_to('oracle_dbfs::config') }

        it { should contain_oracle_dbfs__mount('/mnt/dbfs') }

        it { should contain_exec('create /etc/fuse.conf') }
        it { should contain_exec('mkdir_p /mnt/dbfs') }
        it { should contain_exec('mkdir_p config_dir').that_comes_before('File[/etc/oracle/dbfs]') }
        it { should contain_file('/etc/oracle/dbfs/wallet/cwallet.sso').with_ensure('file') }
        it { should contain_file('/etc/oracle/dbfs/wallet/ewallet.p12').with_ensure('file') }
        it { should contain_file('/etc/oracle/dbfs/admin/tnsnames.ora').with_ensure('file') }
        it { should contain_file('/etc/oracle/dbfs/admin/sqlnet.ora').with_ensure('file') }
        it { should contain_file('/etc/sysconfig/oracle_dbfs.mounts') }
        it { should contain_file('/etc/init.d/oracle_dbfs') }
        it { should contain_file('/etc/sysconfig/oracle_dbfs')
          .with_content(/TNS_ADMIN="\/etc\/oracle\/dbfs\/admin"/) }

        it { should contain_concat('/etc/sysconfig/oracle_dbfs.mounts').with_ensure('present') }
        it { should contain_concat__fragment('Add header in /etc/sysconfig/oracle_dbfs.mounts').with_content(/puppet/) }
        it { should contain_concat__fragment('Add /mnt/dbfs in /etc/sysconfig/oracle_dbfs.mounts').with_content(/\/mnt\/dbfs/) }
        it { should contain_file('/etc/oracle/dbfs').with_ensure('directory') }
        it { should contain_file('/etc/oracle/dbfs/admin').with_ensure('directory') }
        it { should contain_file('/etc/oracle/dbfs/wallet').with_ensure('directory') }
        it { should contain_file('/usr/local/lib64/libfuse.so').with_ensure('link') }

        it { should contain_file_line('fuse user_allow_other') }

        it { should contain_package('fuse') }
        it { should contain_package('fuse-libs') }

        it { should contain_service('oracle_dbfs') }
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
