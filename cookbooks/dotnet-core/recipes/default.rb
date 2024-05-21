if node['platform_family'] == 'debian'
  node['dotnet-core']['packages']['debian'].each do |package_name|
    package package_name
  end
elsif node['platform'] == 'mac_os_x'
  homebrew_cask 'dotnet-sdk' do
    install_cask false
  end
end
