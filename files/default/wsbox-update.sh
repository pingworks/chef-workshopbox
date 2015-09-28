#!/bin/bash

TS=$(date +%Y-%m-%d_%H%M%S)

mkdir /var/tmp/$TS

cat <<EOF > /var/tmp/$TS/node.json
{
  "run_list": "recipe[ws-workshopbox::default]"
}
EOF

cat <<EOF > /var/tmp/$TS/solo.rb
cookbook_path [ "/opt/workshopbox/lib/cookbooks" ]
log_level :info
log_location "/var/tmp/${TS}/log"
verify_api_cert true
EOF

chef-solo -j /var/tmp/${TS}/node.json -c /var/tmp/${TS}/solo.rb
