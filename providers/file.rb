#include Chef::Resource::HTTPRequest

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources if defined?(use_inline_resources)

action :create do
  Chef::Log.info "Fetching #{ new_resource.name } from asset provider if it changed."

    f = remote_file new_resource.name do
      source ::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.source)
      headers ::LeCafeAutomatique::Chef::AssetProvider.headers(node, new_resource.name)
      use_etag
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      mode new_resource.mode if new_resource.mode
      action :nothing
    end

    http_request "HEAD #{::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.source)}" do
      message ""
      url ::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.source)
      headers ::LeCafeAutomatique::Chef::AssetProvider.headers(node, new_resource.name)
      action :head
      notifies :create, "remote_file[#{new_resource.name}]", :immediately
    end

    new_resource.updated_by_last_action(f.updated_by_last_action?)
end
