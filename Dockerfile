FROM kjbreil/arch-build
MAINTAINER kjbreil
ENV TERM=xterm
ADD etc/* /etc/
RUN pacman -Syuu --needed --asdeps --noconfirm yaourt sudo && \
	chmod 440 /etc/sudoers && \
	useradd -m -g root -G wheel -s /bin/bash yaourt
USER yaourt
CMD ["make", "inside"]