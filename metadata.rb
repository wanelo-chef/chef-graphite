name             'graphite'
maintainer       'Wanelo, Inc'
maintainer_email 'dev@wanelo.com'
license          'MIT'
description      'Install graphite on SmartOS'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

supports 'smartos'

depends 'smf'
depends "python"
#
#suggests "graphiti"
