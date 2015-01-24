# asset_provider

Provides two LWRPs to manage the fetching of remote resources: `asset_provider_directory` and `asset_provider_file`.

# Requirements

# Usage

# Attributes
It's so much better if you take a look at the `attributes/default.rb` file for the full list, but this is a brief summary:

* **node[:asset_provider][:username]**   - Basic Authentication username. Default is: 'username'.
* **node[:asset_provider][:password]**   - Basic Authentication password. Default is: 'password'.
* **node[:asset_provider][:host]**   - Asset Provider hostname or IP. Default is: 'localhost'.
* **node[:asset_provider][:port]**   - Asset Provider TCP port. Default is: '8080'.


# Recipes

# Author

Author:: Tnarik Innael (tnarik@lecafeautomatique.co.uk)