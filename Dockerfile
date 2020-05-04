FROM ubuntu:19.10

# Install dependencies
RUN apt-get update && \
    apt-get install -qqy \
    g++ \
    git \
    make \
    cmake \
    python3 \
    python3-dev \
    python3-pip \
    --no-install-recommends

# Copy all files to container
COPY ./ /seal-python

# Build SEAL
RUN cd /seal-python/SEAL/native/src && \
    cmake . && \
    make && \
    make install

# Install requirements
RUN cd /seal-python && \
    pip3 install -r requirements.txt

# Build pybind11
RUN cd /seal-python/pybind11 && \
    mkdir build && \
    cd /seal-python/pybind11/build && \
    cmake .. && \
    make check -j 4 && \
    make install

# Build wrapper
RUN cd /seal-python && \
    python3 setup.py build_ext -i && \
    python3 setup.py install

# Clean-up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
