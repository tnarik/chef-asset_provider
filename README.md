# asset_provider

Provides two LWRPs to manage the fetching of remote resources: `asset_provider_directory` and `asset_provider_file`.

The main reason to create this cookbook was the `asset_provider_directory` LWRP, to allow for a simple way of transferring full directories as tarballs from a remote HTTP/S server to a node being converged.

Typically this LWRP is used with [piedesaint](https://rubygems.org/gems/piedesaint), as this lightweight server based on [Puma](https://rubygems.org/gems/puma) supports the transfer of full directories via cached tarballs, created on the fly.

In addition to this, by centralizing the configuration of the asset provider server, it declutters the configuration of multiple remote sources from the same endpoint.

# Requirements

This is a Chef Cookbook and therefore requires a [Chef](https://www.chef.io/) installation.

When using the `asset_provider_directory` LWRP, an accessible `tar` installation is expected in the converging node. 

# Usage

Typically this cookbook will be used as a dependency of more complex one introducing recipes.

Add the corresponding dependency to the `metadata.rb` or any other dependency description file.

```
%w{asset_provider}.each do |cookbook|
  depends cookbook
end
```

Then, set the correct node attributes to point to your asset provider and have fun using `assset_provider_directory` and `asset_provider_file`. 

# Attributes
It's so much better if you take a look at the `attributes/default.rb` file for the full list, but this is a brief summary:

* **node[:asset_provider][:username]**   - Basic Authentication username. Default is: 'user'.
* **node[:asset_provider][:password]**   - Basic Authentication password. Default is: 'password'.
* **node[:asset_provider][:protocol]**   - Asset Provider protocol. Default is: 'http'.
* **node[:asset_provider][:host]**   - Asset Provider hostname or IP. Default is: 'localhost'.
* **node[:asset_provider][:port]**   - Asset Provider TCP port. Default is: '8080'.


# LWRPs
##asset_provider_directory
###syntax
```
execute "copy_#{web_server_name}_untared" do
  command "cp -r /tmp/untarred/#{web_server_name}/* #{web_server[:root]}"
  user node[:apache][:user]
  group node[:apache][:group]
  action :nothing
end

asset_provider_directory web_server_name do
  tmp_folder '/tmp/untarred'
  chown_user node['apache']['user']
  chown_group node['apache']['group']
  notifies :run, "execute[copy_#{web_server_name}_untared]", :immediately
end
```

This example will fetch the `web_server_name` resource from the asset provider, untar it, assign it to `node['apache']['user']:node['apache']['group']` and then copy it to the root of the web server.

###attributes
| Attribute |      Description      |  Example | Default |
|-----------|:----------------------|---------:|:-------:|
| name        | Resource name. It will be used to set the 'tmp_file' if that attribute is missing | 'myserver' | '' |
| source      | Path to the source folder in the asset provider server | 'myserver.backup.latest' | '' |
| owner       | User which will own the tar file once fetched | 'admin' | nil |
| group       | Group which will own the tar file once fetched | 'admin' | nil |
| user        | User to execute the untarring | 'admin' | nil |
| chown_user  | User to set as owner after untarring | 'foo' | nil |
| chown_group | User to set as group after untarring | 'users' | nil |
| tmp_file    | File name for the fetched tarball | 'backup.temporary.tar' | nil |
| tmp_folder  | Folder where the temporary tar file will be untarred | '/tmp/untarred' | nil |

`tmp_file` will be automatically set based on `name` if it is not specified, like this;

```
tmp_file = File.join(Chef::Config[:file_cache_path], "#{new_resource.name}.tar")
```

* `owner` and `group` are used to assing permissions to the fetched resource.
* `user` is used to execute the untarring.
* `chown_user` and `chown_group` are used at the very last step.


##asset_provider_file
###example
```
asset_provider_file "/tmp/backup_file" do
  source 'backup.latest'
  owner 'apache'
  group 'apache'
  mode "0744"
  notifies :run, "bash[import_backup_file]", :immediately
end
```
###attributes
| Attribute |      Description      |  Example | Default |
|-----------|:----------------------|---------:|:-------:|
| name   | Destination path of the file in the node   | '/tmp/backup_file' | '' |
| source | Path to the source file in the asset provider server | 'backup.latest' | '' |
| owner  | User which will own the file once fetched  | 'admin' | nil |
| group  | Group which will own the file once fetched | 'admin' | nil |
| mode   | File permissions                           | '0744'  | '' |


# Author

Author:: Tnarik Innael (tnarik@lecafeautomatique.co.uk)