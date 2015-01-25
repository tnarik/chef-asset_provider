actions :create
default_action :create

attribute :name, :kind_of => String
attribute :source, :kind_of => String
attribute :user, :kind_of => String, :default => nil
attribute :owner, :kind_of => String, :default => nil
attribute :group, :kind_of => String, :default => nil
attribute :tmp_file, :kind_of => String, :default => nil
attribute :tmp_folder, :kind_of => String
attribute :chown_user, :kind_of => String, :default => nil
attribute :chown_group, :kind_of => String, :default => nil