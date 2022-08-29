FROM osrf/ros:noetic-desktop-full

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV HOME /home/$USERNAME

# Create non-root user
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    curl \
    git \
    zsh \
    autojump \
    python3-catkin-tools \
    clang-format

# Fetch clang-cmake tool
RUN git clone https://github.com/Huoleit/cmake_clang_tools.git /tmp/clang_tool

RUN cd /tmp/clang_tool && mkdir build && cd build \
    && cmake .. && make && make install

# Casadi
ENV CASADI_DIR /tmp/casadi
RUN git clone https://github.com/casadi/casadi.git $CASADI_DIR
RUN cd ${CASADI_DIR} && git checkout 3.5.5
RUN mkdir ${CASADI_DIR}/build && \
    cd ${CASADI_DIR}/build && \
    cmake -DWITH_CPLEX=OFF -DWITH_KNITRO=OFF -DWITH_OOQP=OFF -DWITH_SNOPT=OFF $CASADI_DIR && \
    make -j8 && make install

# Filter
ENV FILTER_DIR /tmp/filter
RUN git clone https://github.com/ShuoYangRobotics/gram_savitzky_golay.git --recurse-submodules $FILTER_DIR
RUN mkdir ${FILTER_DIR}/build && cd ${FILTER_DIR}/build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && make install
##################
## Copy scripts ##
##################

COPY ./scripts/ /tmp/scripts/
RUN chown -R $USERNAME:$USERNAME /tmp/scripts

ENV SHELL /bin/zsh