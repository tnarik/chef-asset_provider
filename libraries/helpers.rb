#
# Cookbook Name:: asset_provider
# Library:: helpers
#
# Copyright (c) 2015 Tnarik Innael, All Rights Reserved.

module LeCafeAutomatique
  module Chef
    class AssetProvider
      def self.url(node, file)
        "#{node['asset_provider']['protocol']}://#{node['asset_provider']['host']}:#{node['asset_provider']['port']}/#{file}"
      end

      def self.headers(node, filename)
        combined_credentials = "#{node['asset_provider']['username']}:#{node['asset_provider']['password']}"
        if ::File.exists?(filename)
          { "Authorization" => "Basic #{Base64.encode64(combined_credentials)}",
            "If-None-Match" => Digest::MD5.file(filename).base64digest
          }
        else
          { "Authorization" => "Basic #{Base64.encode64(combined_credentials)}" }
        end
      end
    end
  end
end