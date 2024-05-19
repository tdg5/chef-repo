default['liquidprompt']['installation'] = {
  'group' => node['root_user']['group'],
  'owner' => node['root_user']['username'],
  'path' => '/opt/liquidprompt',
  'repository' => 'https://github.com/nojhan/liquidprompt.git',
  'revision' => 'v2.1.2',
}
