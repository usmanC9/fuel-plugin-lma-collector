#    Copyright 2015 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#

define lma_collector::afd_filter (
    $type,
    $cluster_name,
    $logical_name,
    $alarms,
    $alarms_definitions,
    $message_matcher,
) {
    include lma_collector::params
    include lma_collector::service
    include heka::params

    $alarms_dir = $heka::params::lua_modules_dir
    $afd_file   = "${alarms_dir}/lma_alarms_${name}.lua"


    # Create the Lua structures that describe alarms
    file { $afd_file:
      ensure  => present,
      content => template('lma_collector/lma_alarms.erb'),
    }

    # Create the confguration file for Heka
    heka::filter::sandbox { "afd_${type}_${cluster_name}_${logical_name}":
      config_dir      => $lma_collector::params::config_dir,
      filename        => "${lma_collector::params::plugins_dir}/filters/afd.lua",
      message_matcher => "(Type == \'metric\' || Type == \'heka.sandbox.metric\') && (${message_matcher})",
      ticker_interval => 10,
      config          => {
        hostname         => $::hostname,
        afd_type         => $type,
        afd_file         => "lma_alarms_${name}",
        afd_cluster_name => $cluster_name,
        afd_logical_name => $logical_name,
      },
      require         => File[$afd_file],
      notify          => Class['lma_collector::service'],
    }
}

