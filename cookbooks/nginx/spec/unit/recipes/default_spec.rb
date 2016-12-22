#
# Cookbook Name:: nginx
# Spec:: default

require 'spec_helper'

describe 'nginx::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.0')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs epel-release and nginx' do
      expect(chef_run).to install_package('epel-release')
      expect(chef_run).to install_package('nginx')
    end

    it 'creates nginx.con with attributes' do
      expect(chef_run).to create_template('/etc/nginx/nginx.conf').with(
        user: 'root',
        group: 'root',
        mode: '0644'
      )
    end

    it 'starts a service with an explicit action' do
      expect(chef_run).to start_service('nginx')
    end
  end
end
