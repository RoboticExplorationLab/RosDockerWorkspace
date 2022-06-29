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
    clang-format \
    libglfw3 \
    libglfw3-dev

# Fetch clang-cmake tool
RUN git clone https://github.com/Huoleit/cmake_clang_tools.git /tmp/clang_tool

RUN cd /tmp/clang_tool && mkdir build && cd build \
    && cmake .. && make && make install

RUN cd $HOME && git clone https://github.com/deepmind/mujoco.git \
    && cd $HOME/mujoco && mkdir build_dir && cd build_dir \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/opt/mujoco \
    && cmake --build . && make install

##################
## Copy scripts ##
##################

COPY ./scripts/ /tmp/scripts/
RUN chown -R $USERNAME:$USERNAME /tmp/scripts

ENV SHELL /bin/zsh

