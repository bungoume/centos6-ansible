# Ansible Dockerfile for CentOS6
FROM centos:6

RUN \
  # for Ansible
  yum clean all && \
  yum -y install gcc libffi-devel openssl-devel python-devel openssh-clients tar unzip sudo rsyslog openssh-server upstart wget && \
  # for CircleCI2.0
  yum -y install ssh tar gzip ca-certificates && \
  mv /sbin/initctl /sbin/initctl.bak && ln -s /bin/true /sbin/initctl && \
  sed -i -e 's/requiretty/!requiretty/' /etc/sudoers && \
  curl -O https://bootstrap.pypa.io/2.6/get-pip.py && python get-pip.py && \
  pip install PyYAML==3.11 pycparser==2.18 idna==2.7 && \
  pip install ansible==1.9.6 && \
  #curl https://packagecloud.io/install/repositories/omnibus-serverspec/serverspec/script.rpm.sh | sh && \
  #yum -y install serverspec && \
  # install chrony
  curl -O http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
  rpm -ivh epel-release-6-8.noarch.rpm && \
  yum -y install chrony && \
  # install git2 for CircleCI2.0
  yum -y install gcc curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker && \
  cd /tmp && \
  curl -O https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.17.1.tar.gz && \
  tar -zxf git-2.17.1.tar.gz && \
  cd git-2.17.1 && \
  make prefix=/usr/local all && make prefix=/usr/local install && \
  cd && \
  yum clean all && rm -rf /tmp/* /var/tmp/* /var/cache/yum/* /root/.cache/pip/*

WORKDIR /data
ENTRYPOINT ["/bin/bash"]
