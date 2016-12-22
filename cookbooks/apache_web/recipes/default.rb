package 'httpd' do
  action :install
end

file '/var/www/html/index.html' do
  content "<h1>I am served from instance name #{node['apache_web']['instance_name']}!<h1>"
  action :create
end

service 'httpd' do
  action :start
end