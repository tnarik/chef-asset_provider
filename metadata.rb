name             'asset_provider'
maintainer       'Tnarik Innael'
maintainer_email 'tnarik@lecafeautomatique.co.uk'
license          'all_rights'
description      'Installs/Configures asset_provider'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/tnarik/chef-asset_provider'
issues_url       'https://github.com/tnarik/chef-asset_provider/issues'
version          '0.2.0'

%w{centos fedora redhat debian ubuntu solaris solaris2}.each do |os|
  supports os
end