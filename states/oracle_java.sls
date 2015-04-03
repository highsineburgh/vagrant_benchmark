python-pycurl:
  pkg:
    - installed

python-software-properties:
  pkg:
    - installed
    - require:
      - pkg: python-pycurl

webupd8:
  pkgrepo.managed:
    - names:
      - deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
      - deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
    - file: /etc/apt/sources.list.d/webupd8team-java.list
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: oracle-java7-installer

oracle-license-select:
  cmd.run:
    - name: '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections'
    - require_in:
      - pkg: oracle-java7-installer
      - cmd: oracle-license-seen-lie

oracle-license-seen-lie:
  cmd.run:
    - name: '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections'
    - require_in:
      - pkg: oracle-java7-installer

oracle-java7-installer:
  pkg:
    - installed
    - refresh: True

oracle-java7-set-default:
  pkg:
    - installed
    - require:
      - pkg: oracle-java7-installer
