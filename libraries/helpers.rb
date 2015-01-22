#
# Cookbook Name:: asset_provider
# Library:: helpers
#
# Copyright (c) 2015 Tnarik Innael, All Rights Reserved.

module LeCafeAutomatique
  module Chef
    class AssetProvider
      def self.url(node, file)
        "https://#{node[:asset_provider][:username]}:#{node[:asset_provider][:password]}@#{node[:asset_provider][:host]}:#{node[:asset_provider][:port]}/#{file}"
      end
    end
  end
end