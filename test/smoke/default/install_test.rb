# # encoding: utf-8

# Inspec test for recipe exiftool::install

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/tmp/kitchen/cache/exiftool.tar.gz') do
  it { should_not exist }
end

describe directory('/tmp/kitchen/cache/Image-ExifTool-10.93') do
  it { should_not exist }
end

describe file('/usr/local/bin/exiftool') do
  it { should exist }
  it { should be_executable }
  it { should be_executable.by('others') }
  it { should be_grouped_into 'root' }
  it { should be_owned_by 'root' }
end
