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
      headers ::LeCafeAutomatique::Chef::AssetProvider.headers(node)
      use_etag
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      mode new_resource.mode if new_resource.mode
    end

    http_request "HEAD #{::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.source)}" do
      message ""
      url ::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.source)
      headers ::LeCafeAutomatique::Chef::AssetProvider.headers(node)
      action :head
      if ::File.exists?(new_resource.name)
        headers "If-None-Match" => Digest::MD5.file(new_resource.name).base64digest
      end
      notifies :create, "remote_file[#{new_resource.name}]", :immediately
    end

    new_resource.updated_by_last_action(f.updated_by_last_action?)
end
