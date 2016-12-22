require 'spec_helper'

require 'net/http'

describe package('nginx'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe service('nginx'), :if => os[:family] == 'redhat' do
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe 'Nginx reverse proxy' do
  let(:http) { Net::HTTP.new('127.0.0.1', port) }
  let(:public_ip) do
    Socket
      .ip_address_list
      .find { |addr| addr.ipv4? && !addr.ipv4_loopback? }
      .ip_address
  end

  describe 'nginx' do
    let(:port) { 80 }

    it 'listens on localhost' do
      expect { rescuing { TCPSocket.new('127.0.0.1', port).close }.nil? }
    end

    it 'listens globally' do
      expect { rescuing { TCPSocket.new(public_ip, port).close }.nil? }
    end

    it 'is handling reverse proxy to one of the defined host' do
      resp = http.request(Net::HTTP::Get.new('/'))
      expect(resp.code).to match(/200/)
      expect(resp['server']).to match(/nginx\/1.10.2/)
      expect(resp.body).to match(/<h1>I am served from instance name web-[1-4]!<h1>/)
    end

    it 'is handling static resources' do
      resp = http.request(Net::HTTP::Get.new('/text/info.txt'))
      expect(resp.code).to match(/200/)
      expect(resp['server']).to match(/nginx\/1.10.2/)
      expect(resp.body).to match(/This is a test file to show nginx static file serving capability/)
    end
  end
end
