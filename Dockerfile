FROM debian

RUN dpkg --add-architecture i386 && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y wine qemu-kvm xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-system i965-va-driver mesa-utils libglx-mesa0 libgl1-mesa-dri && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz && \
    rm v1.2.0.tar.gz

RUN mkdir $HOME/.vnc && \
    echo 'password' | vncpasswd -f > $HOME/.vnc/passwd && \
    echo '#!/bin/bash\nstartmate &' > $HOME/.vnc/xstartup && \
    chmod 600 $HOME/.vnc/passwd

RUN echo '#!/bin/bash\n' > /start.sh && \
    echo 'vncserver :1 -geometry 1280x800 -depth 24' >> /start.sh && \
    echo './noVNC-1.2.0/utils/launch.sh --vnc localhost:5901 --listen 8900' >> /start.sh && \
    chmod +x /start.sh

RUN echo '#!/bin/bash\n' > /x11vnc.sh && \
    echo 'x11vnc -display :1 -rfbport 5901 & \n' >> /x11vnc.sh && \
    echo './noVNC-1.2.0/utils/launch.sh --vnc localhost:5901 --listen 8900' >> /x11vnc.sh && \
    chmod +x /x11vnc.sh

EXPOSE 8900
CMD ["/start.sh"]
