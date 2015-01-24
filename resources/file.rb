actions :create
default_action :create

attribute :name, :kind_of => String
attribute :source, :kind_of => String
attribute :owner, :kind_of => String, :default => nil
attribute :group, :kind_of => String, :default => nil
attribute :mode, :kind_of => String
