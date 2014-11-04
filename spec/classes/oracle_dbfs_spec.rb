require 'spec_helper'

describe 'oracle_dbfs' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      describe "oracle_dbfs class without any parameters on #{osfamily}" do
        let(:params) {{
          :conn_string      => 'dbfs_user@DBFS',
          :mount_point      => '/mnt/dbfs',
          :mount_opts       => '-o wallet -o rw -o allow_other',
          :configure_fstab  => true,
          :user_allow_other => true,
          :ewallet_content  => 'ewallet content',
          :cwallet_content  => 'cwallet content',
          :tnsnames         => 'tnsnames content',
          :sqlnet           => 'sqlnet content',
        }}
        let(:facts) {{
          :osfamily     => osfamily,
          :architecture => 'x86_64',
        }}

        it { should compile.with_all_deps }

        it { should contain_class('oracle_dbfs') }
        it { should contain_class('oracle_dbfs::params') }
        it { should contain_class('oracle_dbfs::install').that_comes_before('oracle_dbfs::config') }
        it { should contain_class('oracle_dbfs::config') }
        it { should contain_class('oracle_dbfs::service').that_subscribes_to('oracle_dbfs::config') }

        it { should contain_exec('create /etc/fuse.conf') }
        it { should contain_exec('/etc/oracle/dbfs/wallet').that_comes_before('File[/etc/oracle/dbfs/wallet]') }
        it { should contain_file('/etc/oracle/dbfs/wallet/cwallet.sso').with_ensure('file') }
        it { should contain_file('/etc/oracle/dbfs/wallet/ewallet.p12').with_ensure('file') }
        it { should contain_file('/etc/oracle/dbfs/admin/tnsnames.ora').with_ensure('file') }
        it { should contain_file('/etc/oracle/dbfs/admin/sqlnet.ora').with_ensure('file') }
        it { should contain_file('/etc/oracle/dbfs/admin').with_ensure('directory') }
        it { should contain_file('/etc/oracle/dbfs/wallet').with_ensure('directory') }
        it { should contain_file('/mnt/dbfs').with_ensure('directory') }
        it { should contain_file('/usr/local/lib64/libfuse.so').with_ensure('link') }

        it { should contain_file_line('fuse user_allow_other') }
        it { should contain_file_line('fstab_rule') }

        it { should contain_package('fuse') }
        it { should contain_package('fuse-libs') }

        it { should contain_exec('umount oracle_dbfs').that_comes_before('Exec[mount oracle_dbfs]') }
        it { should contain_exec('mount oracle_dbfs') }

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
