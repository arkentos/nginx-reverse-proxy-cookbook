package 'epel-release' do
  action :install
end

package 'nginx' do
  action :install
end

node['nginx']['static_folders'].each do |folder|
  directory File.join(node['nginx']['server_root'], folder) do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file File.join(node['nginx']['server_root'], 'images', 'logo1.png') do
  source 'logo1.png'
  owner 'root'
  group 'root'
  mode '0644'
end

%w(logo1.png mint.jpeg).each do |image|
  cookbook_file File.join(node['nginx']['server_root'], 'images', image) do
    source image
    owner 'root'
    group 'root'
    mode '0644'
  end
end

cookbook_file File.join(node['nginx']['server_root'], 'text', 'info.txt') do
  source 'info.txt'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'nginx' do
  action :start
end
