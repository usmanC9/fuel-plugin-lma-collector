# Copyright 2016 Mirantis, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

notice('fuel-plugin-lma-collector: cleanup_collector.pp')

Exec {
  path => '/usr/sbin:/sbin',
  logoutput => on_failure,
}

exec { 'cleanup log_collector':
  command => 'crm resource cleanup log_collector'
}

exec { 'cleanup metric collector':
  command => 'crm resource cleanup metric_collector'
}