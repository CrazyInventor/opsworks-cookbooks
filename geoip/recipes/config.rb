#
# Cookbook Name:: geoip
# Recipe:: config
#
# Copyright (C) 2015 David Schneider
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# Write config file for GeoIP
unless node["geoip"]["UserId"].empty?
	# Github Oauth token
	template "/usr/local/etc/GeoIP.conf" do
		source 'geoip_conf.erb'
		mode '0644'
		owner "root"
		group "root"
		variables(
			:UserId => node["geoip"]["UserId"],
			:LicenseKey => node["geoip"]["LicenseKey"],
			:ProductIds => node["geoip"]["ProductIds"]
		)
	end
end

# Update GeoIP databases
script "run_geoipupdate" do
	interpreter "bash"
	user "root"
	cwd "/usr/local/share"
	code <<-EOH
		geoipupdate
	EOH
end

# Create link to fix path bug
link '/usr/share/GeoIP/GeoIPRegion.dat' do
  to '/usr/local/share/GeoIP/GeoIPRegion.dat'
  link_type :symbolic 
  :create
end