name 'snowflake-snowsql'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install snowflake-snowsql via brew'
long_description  'Install snowflake-snowsql via brew'
version           '0.0.1'

recipe 'snowflake-snowsql', 'Install snowflake-snowsql package'

%w[ darwin ].each { |os| supports os }
