################################################################################
# Base Image
################################################################################

ARG BASE_IMAGE=osrf/ros:rolling-desktop

FROM ${BASE_IMAGE}

USER root

################################################################################
# Install requirements
################################################################################

# Copy requirement files and install dependencies
COPY requirements.txt .
RUN apt-get update && apt-get install --no-install-recommends -y $(cat requirements.txt)
RUN rm requirements.txt

################################################################################
# Development with a user
################################################################################

ARG USERNAME=ros_user
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG BASHRC_APPEND

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -s "/bin/bash" -m $USERNAME && \
    apt-get install -y sudo && \
    echo "${USERNAME} ALL=NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}
RUN echo "export PS1='\[\033[01;36m\](docker)\[\033[00m\] \[\033[01;32m\]\u@${NAME}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/${USERNAME}/.bashrc && \
    echo "alias ll='ls --color=auto -alFNh'" >> /home/${USERNAME}/.bashrc && \
    echo "alias ls='ls --color=auto -Nh'" >> /home/${USERNAME}/.bashrc

# Check if the directory /opt/ros/ exists, and if it does, append the command to .bashrc
RUN if [ -d /opt/ros/ ]; then \
    echo "source /opt/ros/$(ls /opt/ros/)/setup.bash" >> /home/${USERNAME}/.bashrc; \
    fi

# Check if /usr/share/colcon_argcomplete/ is installed, and if it does, append the arg complete command to .bashrc
RUN if [ -d /usr/share/colcon_argcomplete/ ]; then \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> /home/${USERNAME}/.bashrc; \
    fi

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# If BASHRC_APPEND is set, append it to .bashrc
RUN if [ -n "${BASHRC_APPEND}" ]; then \
    echo "${BASHRC_APPEND}" >> /home/${USERNAME}/.bashrc; \
    fi

CMD ["/bin/bash"]
