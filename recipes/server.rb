include_recipe "percona::package_repo"

# install packages
case node["platform_family"]
when "debian"
  node["percona"]["server"]["packages"].each do |pkg|
    package pkg do
      action :install
      options "--force-yes"
    end
  end
when "rhel"
  # Need to remove this to avoid conflicts
  package "mysql-libs" do
    action :remove
    not_if "rpm -qa | grep Percona-Server-shared"
  end

  # we need mysqladmin
  include_recipe "percona::client"

  node["percona"]["server"]["packages"].each do |pkg|
    package pkg do
      action :install
    end
  end
end

include_recipe "percona::configure_server"

# access grants
include_recipe "percona::access_grants"

include_recipe "percona::replication"
