#
# Cookbook:: exiftool
# Recipe:: install
#
# Copyright:: 2018, The Authors, All Rights Reserved.

upstream = node['exiftool']['upstream']
version = node['exiftool']['version']

package 'perl-ExtUtils-MakeMaker'
package 'automake'

# A user for doing stuff that we don't (and shouldn't) be root to do
lowpriv_user = 'chef'
user lowpriv_user do
  system true
end

tar = "#{Chef::Config[:file_cache_path]}/exiftool.tar.gz"
remote_file tar do
  source "#{upstream}/Image-ExifTool-#{version}.tar.gz"
  not_if { ::File.exists? '/usr/local/bin/exiftool' }
end

execute 'untar' do
  command "tar -xf #{tar}"
  cwd Chef::Config[:file_cache_path]
  only_if { ::File.exists? tar }
  notifies :run, 'execute[chown]', :immediately
end

source_dir = "#{Chef::Config[:file_cache_path]}/Image-ExifTool-#{version}"
execute 'chown' do
  command "chown #{lowpriv_user}:#{lowpriv_user} #{source_dir}"
  action :nothing
end

file tar do
  action :delete
end

execute 'MakeMaker' do
  command 'perl Makefile.PL'
  cwd source_dir
  user lowpriv_user
  only_if { ::Dir.exist? source_dir }
  not_if { ::File.exist? "#{source_dir}/Makefile" }
end

execute 'make' do
  user lowpriv_user
  cwd source_dir
  only_if { ::File.exist? "#{source_dir}/Makefile" }
  not_if { ::Dir.exist? "#{source_dir}/blib" }
end

execute 'make install' do
  user 'root'
  cwd source_dir
  only_if { ::Dir.exist? "#{source_dir}/blib" }
  not_if { ::File.exists? '/usr/local/bin/exiftool' }
end

directory source_dir do
  action :delete
  recursive true
end
