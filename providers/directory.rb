#include Chef::Resource::HTTPRequest

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources if defined?(use_inline_resources)

action :create do
  Chef::Log.info "Fetching #{ new_resource.source } from asset provider if it changed."

    if tmp_file.nil?
      tmp_file = File.join(Chef::Config[:file_cache_path], "#{new_resource.name}.tar")
    end

    directory new_resource.tmp_folder do
      recursive true
      mode 0770
      not_if { ::File.directory?(new_resource.tmp_folder) }
    end

    execute "extract_#{new_resource.name}" do
      tar_command = "tar xvf #{new_resource.tmp_file} -C #{new_resource.tmp_folder}"
      if new_resource.chown_user
        chown_command = "chown -R #{new_resource.chown_user}:#{new_resource.chown_group} #{new_resource.tmp_folder}/#{new_resource.name}"
        command "#{tar_command}; #{chown_command}"
      else
        command tar_command
      end
      user new_resource.user if new_resource.user
      action :nothing
    end
    
    f = remote_file new_resource.tmp_file do
      source ::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.source)
      headers ::LeCafeAutomatique::Chef::AssetProvider.headers(node, new_resource.name)
      use_etag
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      action :nothing
      notifies :run, "execute[extract_#{new_resource.name}]", :immediately
    end

    http_request "HEAD #{::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.source)}" do
      message ""
      url ::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.source)
      headers ::LeCafeAutomatique::Chef::AssetProvider.headers(node, new_resource.name)
      action :head
      notifies :create, "remote_file[#{new_resource.tmp_file}]", :immediately
    end

    new_resource.updated_by_last_action(f.updated_by_last_action?)
end
