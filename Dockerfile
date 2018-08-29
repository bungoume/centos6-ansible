# Ansible Dockerfile for CentOS6
FROM centos:6

# for Ansible
RUN \
  yum clean all && \
  yum -y install gcc libffi-devel openssl-devel python-devel openssh-clients tar unzip sudo rsyslog openssh-server upstart && \
  mv /sbin/initctl /sbin/initctl.bak && ln -s /bin/true /sbin/initctl && \
  sed -i -e 's/requiretty/!requiretty/' /etc/sudoers && \
  curl -O https://bootstrap.pypa.io/2.6/get-pip.py && python get-pip.py && \
  pip install PyYAML==3.11 ansible==1.9.6 && \
  curl https://packagecloud.io/install/repositories/omnibus-serverspec/serverspec/script.rpm.sh | sh && \
  yum -y install serverspec

# install chrony
RUN yum -y install wget && \
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    rpm -ivh epel-release-6-8.noarch.rpm && \
    yum -y install chrony

WORKDIR /data
ENTRYPOINT ["/bin/bash"]
