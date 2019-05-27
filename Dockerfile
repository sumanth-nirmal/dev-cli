# Ubuntu 18.04 with nvidia-docker2, cuda-10.1, and opengl support
FROM nvidia/cudagl:10.1-devel-ubuntu18.04

MAINTAINER Sumanth Nirmal "sumanth.724@gmail.com"

# Some tools for development
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y \
        wget \
        lsb-release \
        sudo \
        mercurial \
        git \
        git-gui \
        vim \
        cmake \
        gdb \
        software-properties-common \
        python3-dbg \
        python3-pip \
        python3-venv \
        python-pip \
        build-essential \
        ccache \
        mesa-utils \
        htop \
        terminator \
 && apt-get clean

# Setup ccache
ARG ccache_size=2000000k
RUN /usr/sbin/update-ccache-symlinks \
 && touch /etc/ccache.conf \
 && /bin/sh -c 'echo "cache_dir = /ccache\n" >> /etc/ccache.conf' \
 && /bin/sh -c 'echo "max_size = ${ccache_size}" >> /etc/ccache.conf'

# Add a user with the same user_id as the user on the host
ENV USERNAME developer
RUN useradd -ms /bin/bash $USERNAME \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# Commands below run as the developer user
USER $USERNAME

# Add paths for ccache
RUN /bin/sh -c 'echo "export PATH=/usr/lib/ccache:\$PATH" >> ~/.bashrc'

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

RUN sudo apt-get update \
 && sudo -E apt-get install -y \
    tzdata \
 && sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
 && sudo dpkg-reconfigure --frontend noninteractive tzdata \
 && sudo apt-get clean

# Install ROS and Gazebo9
RUN sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
 && sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list \
 && wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -' \
 && sudo apt-get update \
 && sudo apt-get install -y \
    ros-melodic-desktop-full \
    python-catkin-tools \
    python-rosinstall \
    gazebo9 \
    libgazebo9-dev \
 && sudo rosdep init \
 && sudo apt-get clean

RUN rosdep update

# install vscode dpendencies
RUN sudo pip install cpplint
RUN sudo apt-get install -y \
  libxkbfile1 \
  libsecret-1-dev \
  libnss3 \
  libasound2
# Install Visual Studio Code
RUN wget -O vscode-amd64.deb https://go.microsoft.com/fwlink/?LinkID=760868 \
  && sudo dpkg -i vscode-amd64.deb \
  && rm vscode-amd64.deb
# Install required vscode extensions
RUN code --force \
  --install-extension ms-vscode.cpptools  \
  --install-extension ms-python.python  \
  --install-extension eamodio.gitlens  \
  --install-extension peterjausovec.vscode-docker donjayamanne.githistory  \
  --install-extension redhat.vscode-yaml  \
  --install-extension shd101wyy.markdown-preview-enhanced  \
  --install-extension xaver.clang-format  \
  --install-extension ajshort.ros \
  --install-extension davidanson.vscode-markdownlint \
  --install-extension mine.cpplint \
  --install-extension shakram02.bash-beautify \
  --install-extension twxs.cmake \
  --install-extension streetsidesoftware.code-spell-checker \
  --install-extension formulahendry.code-runner

# some utilities
RUN sudo apt-get install -y \
  python-requests

RUN /bin/sh -c 'echo ". /opt/ros/melodic/setup.bash" >> ~/.bashrc' \
 && /bin/sh -c 'echo ". /usr/share/gazebo/setup.sh" >> ~/.bashrc'
