name             'graphite'
maintainer       'Wanelo, Inc'
maintainer_email 'dev@wanelo.com'
license          'MIT'
description      'Install graphite on SmartOS'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.3'

supports 'smartos'

depends 'nginx'
depends 'python'
depends 'smf'
#
#suggests "graphiti"
