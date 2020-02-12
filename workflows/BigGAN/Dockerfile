FROM centos:centos7

RUN yum -y update; yum clean all
RUN yum -y install epel-release gcc openssl-devel bzip2-devel git python37 python3-pip; yum clean all

ADD ./ /BigGAN
WORKDIR /BigGAN

RUN pip3 install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
CMD /bin/sh run.sh
CMD echo "test on centos7"
