FROM debian

# 添加 i386 架构
RUN dpkg --add-architecture i386

# 更新软件包列表
RUN apt update -y

# 安装所需软件包
RUN DEBIAN_FRONTEND=noninteractive apt install -y wine qemu-kvm fonts-wqy-zenhei xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-core mate-desktop-environment-extras

# 清理软件包缓存
RUN apt clean

# 设置默认 shell 为 bash
SHELL ["/bin/bash", "-c"]

# 设置环境变量
ENV DEBIAN_FRONTEND noninteractive

# 暴露 VNC 端口
EXPOSE 8900

# 设置 VNC 密码
ARG VNC_PASSWORD
RUN echo ${VNC_PASSWORD} | vncpasswd -f >> $HOME/.vnc/passwd && \
    chmod 600 $HOME/.vnc/passwd

# 启动脚本
COPY startup.sh $HOME/
RUN chmod +x $HOME/startup.sh

# 启动 VNC 会话
CMD $HOME/startup.sh
