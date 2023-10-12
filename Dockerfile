FROM debian

# 添加 i386 架构
RUN dpkg --add-architecture i386

# 更新包列表
RUN apt update

# 安装所需软件包和工具
RUN DEBIAN_FRONTEND=noninteractive apt install -y wine qemu-kvm *zenhei* xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-desktop-environment-core synaptic gedit git xfce4 xfce4-terminal tightvncserver -qq

# 下载和解压 noVNC
RUN curl -o noVNC.tar.gz https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz && \
    tar -xzvf noVNC.tar.gz && \
    mv noVNC-1.2.0 /opt/noVNC && \
    rm noVNC.tar.gz

# 创建 VNC 密码
RUN mkdir -p $HOME/.vnc && \
    echo "password" | vncpasswd -f > $HOME/.vnc/passwd && \
    chmod 600 $HOME/.vnc/passwd

# 创建 VNC 启动命令
RUN echo "#!/bin/bash" > $HOME/.vnc/xstartup && \
    echo "xrdb $HOME/.Xresources" >> $HOME/.vnc/xstartup && \
    echo "startxfce4 &" >> $HOME/.vnc/xstartup && \
    chmod +x $HOME/.vnc/xstartup

# 创建启动脚本
RUN echo "#!/bin/bash" > $HOME/yang.sh && \
    echo "vncserver :1 -geometry 1360x768 -depth 24 && tail -F $HOME/.vnc/*.log &" >> $HOME/yang.sh && \
    echo "cd /opt/noVNC && ./utils/launch.sh --listen 8900 --vnc localhost:8900" >> $HOME/yang.sh && \
    chmod +x $HOME/yang.sh

# 暴露 5901 端口
EXPOSE 8900

# 运行启动脚本
CMD $HOME/yang.sh
