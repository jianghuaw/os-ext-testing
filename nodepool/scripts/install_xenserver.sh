#!/bin/bash -xe

# Copyright (C) 2011-2013 OpenStack Foundation
# Copyright (c) 2014 Citrix Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.

XENSERVER_XVA_URL=${NODEPOOL_XENSERVER_XVA_URL:-http://downloads.vmd.citrix.com/OpenStack/xenapi-in-the-cloud-appliances/prod_ci}
XENSERVER_ISO_URL=${NODEPOOL_XENSERVER_ISO_URL:-http://downloadns.citrix.com.edgesuite.net/10175/XenServer-6.5.0-xenserver.org-install-cd.iso}

#XENSERVER_ISO_URL=${NODEPOOL_XENSERVER_ISO_URL:-http://downloadns.citrix.com.edgesuite.net/akdlm/8159/XenServer-6.2.0-install-cd.iso}

./convert_node_to_xenserver.sh \
    password \
    "$XENSERVER_XVA_URL" \
    devstack \
    "$XENSERVER_ISO_URL"
