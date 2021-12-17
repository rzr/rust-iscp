#!/bin/echo docker build . -f
# -*- coding: utf-8 -*-
# SPDX-License-Identifier: MPL-2.0
#{
# Copyright: 2021+ Philippe Coval <https://purl.org/rzr/>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/ .
#}

FROM debian:11
LABEL maintainer="Philippe Coval (rzr@users.sf.net)"

RUN echo "#log: Setup system" \
  && set -x \
  && apt-get update \
  && apt-get install -y \
      --no-install-recommends \
     make=4.3-4.1 \
     sudo=1.9.5p2-3 \
  && echo "info: rust it not in main?" \
  && sed -e 's|deb \(.*\) main$|deb \1 main contrib|g' -i /etc/apt/*.list \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
     cargo=0.47.0-3+b1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && date -u

ARG project=rust-iscp
ARG workdir="/local/src/${project}"

COPY . "${workdir}/"
WORKDIR "${workdir}"
RUN echo "#log: ${project}: Preparing sources" \
  && set -x \
  && make setup sudo=sudo \
  && make \
  && date -u

WORKDIR "${workdir}"
ENTRYPOINT [ "/usr/bin/make" ]
CMD [ "run" ]
