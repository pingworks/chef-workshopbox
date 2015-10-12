---
platforms:
  - name: ubuntu-14.04
    driver:
        gui: true
        box: pingworks_ubuntu-14.04_chef-12.4.1-1
        box_url: http://vagrant.pingworks.net/pingworks_ubuntu-14.04_chef-12.4.1-1.box

suites:
  - name: default
    run_list:
      - recipe[workshopbox::default]
    attributes:
      workshopbox:
        mirror:
          apt: 'apt-mirror-ubuntu1404.ws.pingworks.net'
