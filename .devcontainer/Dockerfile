FROM osrf/ros:noetic-desktop-full

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

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
    libglfw3 \
    libglfw3-dev

# Fetch clang-cmake tool
RUN git clone https://github.com/Huoleit/cmake_clang_tools.git /tmp/clang_tool

RUN cd /tmp/clang_tool && mkdir build && cd build \
    && cmake .. && make && make install

COPY activation.raisim $HOME/activation.raisim

RUN sudo apt install -y minizip ffmpeg mesa-vulkan-drivers \
    && cd /opt/ && sudo mkdir raisim_build \
    && cd $HOME && mkdir .raisim && cp activation.raisim .raisim \
    && git clone https://github.com/raisimTech/raisimLib.git \
    && cd $HOME/raisimLib && mkdir build_dir && cd build_dir \
    && cmake .. -DCMAKE_INSTALL_PREFIX=$LOCAL_INSTALL -DRAISIM_EXAMPLE=ON -DRAISIM_PY=ON -DPYTHON_EXECUTABLE=$(python3 -c "import sys; print(sys.executable)") \
    && make install -j4 && echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/raisim_build/lib' >> ~/.zshrc \
    && echo 'export PYTHONPATH=$PYTHONPATH:/opt/raisim_build/lib' >> ~/.zshrc

RUN sudo apt-get install -y gdb

##################
## Copy scripts ##
##################

COPY ./scripts/ /tmp/scripts/
RUN chown -R $USERNAME:$USERNAME /tmp/scripts

ENV SHELL /bin/zsh

