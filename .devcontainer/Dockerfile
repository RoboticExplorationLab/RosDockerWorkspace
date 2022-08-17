FROM osrf/ros:noetic-desktop-full

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG PCAN_DRIVER_VERSION=8.14.0
ARG PCAN_BASIC_API_VERSION=4.6.0

ENV HOME /home/$USERNAME
ENV WORKSPACE /workspaces/RosDockerWorkspace
ENV LOCAL_INSTALL /opt/raisim_build
# prevent yes/no problem
ENV DEBIAN_FRONTEND noninteractive  


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
    clang-format \
    libpopt-dev \
    libglfw3 \
    libglfw3-dev

# Fetch clang-cmake tool
RUN git clone https://github.com/Huoleit/cmake_clang_tools.git /tmp/clang_tool

RUN cd /tmp/clang_tool && mkdir build && cd build \
    && cmake .. && make && make install

# Fetch PCAN driver
RUN curl https://www.peak-system.com/fileadmin/media/linux/files/peak-linux-driver-${PCAN_DRIVER_VERSION}.tar.gz | tar -xz  -C /tmp/
# Fetch PCAN basic API
RUN curl https://www.peak-system.com/produktcd/Develop/PC%20interfaces/Linux/PCAN-Basic_API_for_Linux/PCAN-Basic_Linux-${PCAN_BASIC_API_VERSION}.tar.gz | tar -xz  -C /tmp/

ENV PCAN_DRIVER_DIR=/tmp/peak-linux-driver-${PCAN_DRIVER_VERSION}
ENV PCAN_BASIC_API_DIR=/tmp/PCAN-Basic_Linux-${PCAN_BASIC_API_VERSION}

# Build PCAN driver lib
RUN cd $PCAN_DRIVER_DIR && make -C lib && make -C lib install && make -C test && make -C test install

# Copy headers and helper tools to the systems include folder.
# Note: PCAN driver is installed on the host machine(outside docker). But the headers should be visible inside docker.
# Thus, copy required headers to system include.
RUN cp $PCAN_DRIVER_DIR/driver/pcan.h $PCAN_DRIVER_DIR/driver/pcanfd.h /usr/include/
RUN chmod 644 /usr/include/pcan.h /usr/include/pcanfd.h

RUN cp $PCAN_DRIVER_DIR/driver/lspcan /usr/local/bin/
RUN chmod 755 /usr/local/bin/lspcan

# PCAN basic API
RUN cd ${PCAN_BASIC_API_DIR}/libpcanbasic/pcanbasic && make && make install

# raisim install
COPY activation.raisim $HOME/activation.raisim
RUN sudo apt install -y minizip ffmpeg mesa-vulkan-drivers \
    && cd /opt/ && sudo mkdir raisim_build \
    && cd $HOME && mkdir .raisim && cp activation.raisim .raisim \
    && git clone https://github.com/raisimTech/raisimLib.git \
    && cd $HOME/raisimLib && mkdir build_dir && cd build_dir \
    && cmake .. -DCMAKE_INSTALL_PREFIX=$LOCAL_INSTALL -DRAISIM_EXAMPLE=ON -DRAISIM_PY=ON -DPYTHON_EXECUTABLE=$(python3 -c "import sys; print(sys.executable)") \
    && make install -j4

# mujoco install
RUN cd $HOME && git clone https://github.com/deepmind/mujoco.git \
    && cd $HOME/mujoco && mkdir build_dir && cd build_dir \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/opt/mujoco \
    && cmake --build . && make install

# debugger
RUN sudo apt-get install -y gdb

##################
## Copy scripts ##
##################

COPY ./scripts/ /tmp/scripts/
RUN chown -R $USERNAME:$USERNAME /tmp/scripts

ENV SHELL /bin/zsh
