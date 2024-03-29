require 'spec_helper_acceptance'

describe 'nginx class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = "
      include nginx

      nginx::resource::server { 'example.com':
        ensure   => present,
        www_root => '/var/www/html',
      }
      "

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    # do some basic checks
    pkg = case fact('os.family')
          when 'Archlinux'
            'nginx-mainline'
          else
            'nginx'
          end
    describe package(pkg) do
      it { is_expected.to be_installed }
    end

    describe service('nginx') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(80) do
      it { is_expected.to be_listening }
    end
  end

  context 'with service_config_check true' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = "
      class { 'nginx':
        service_config_check => true,
      }

      nginx::resource::server { 'example.com':
        ensure   => present,
        www_root => '/var/www/html',
      }
      "

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    # do some basic checks
    pkg = case fact('os.family')
          when 'Archlinux'
            'nginx-mainline'
          else
            'nginx'
          end
    describe package(pkg) do
      it { is_expected.to be_installed }
    end

    describe service('nginx') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(80) do
      it { is_expected.to be_listening }
    end
  end
end
