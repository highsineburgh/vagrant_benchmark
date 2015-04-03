elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.deb
  service:
    - name: elasticsearch
    - running
    - enable: True
    - require:
      - pkg: elasticsearch

/data:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - only_if: dpkg -s elasticsearch
    - require:
      - pkg: elasticsearch
