FROM centos:centos7

# Install yum dependencies
RUN yum -y update; yum clean all
RUN yum -y install epel-release gcc openssl-devel bzip2-devel git python37 python3-pip vim; yum clean all

# Add python requirements & install
# Utilize docker cache to prevent pip installing every time
ADD ./requirements.txt /python/requirements.txt
RUN pip3 install --upgrade pip && pip install -r /python/requirements.txt

# Add working directory
ADD ./ /BigGAN
WORKDIR /BigGAN

CMD cd /BigGAN
CMD /bin/sh run.sh
