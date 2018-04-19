#
# Cookbook:: exiftool
# Recipe:: install
#
# Copyright:: 2018, The Authors, All Rights Reserved.

upstream = node['exiftool']['upstream']
version = node['exiftool']['version']

tar = "#{Chef::Config[:file_cache_path]}/exiftool.tar.gz"
remote_file tar do
  source "#{upstream}/Image-ExifTool-#{version}.tar.gz"
  ftp_active_mode node['ftp_active_mode'] if upstream.start_with? 'ftp'
end

execute 'untar' do
  command "tar -xf #{tar}"
  cwd Chef::Config[:file_cache_path]
  only_if { ::File.exists? tar }
end

file tar do
  action :delete
end

dir = "#{Chef::Config[:file_cache_path]}/Image-ExifTool-#{version}"
execute 'Makefile.pl' do
  command 'perl Makefile.PL'
  cwd dir
  only_if { ::Dir.exist? dir }
  not_if { ::File.exist? "#{dir}/Makefile" }
end
