#include Chef::Resource::HTTPRequest

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources if defined?(use_inline_resources)

action :create do
  Chef::Log.info "Fetching #{ new_resource.name } from asset provider if it changed."

    f = remote_file new_resource.file do
      source ::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.name)
      use_etag
      if new_resource.user
        user new_resource.user
      end
    end

    http_request "HEAD #{::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.name)}" do
      message ""
      url ::LeCafeAutomatique::Chef::AssetProvider.url(node, new_resource.name)
      action :head
      if ::File.exists?(new_resource.file)
        headers "If-None-Match" => Digest::MD5.file(new_resource.file).base64digest
      end
      notifies :create, resources(:remote_file => new_resource.file), :immediately
    end

    new_resource.updated_by_last_action(f.updated_by_last_action?)
end
