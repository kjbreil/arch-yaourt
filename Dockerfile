FROM kjbreil/arch-build
MAINTAINER kjbreil
ENV TERM=xterm
COPY etc/* /etc/
COPY pkg /opt/build/pkg
RUN chmod -R 777 /opt/build/pkg 
RUN pacman -Syuu --needed --asdeps --noconfirm yaourt sudo xdelta3 
RUN chmod 440 /etc/sudoers 
RUN groupadd wheel && groupadd users
RUN useradd -m -g root -G wheel -s /bin/bash yaourt 
RUN repo-add /opt/build/pkg/internal.db.tar.gz /opt/build/pkg/*.pkg.tar.xz 
RUN printf '[internal]\nSigLevel = Never\nServer = file:///opt/build/pkg/\n\n' >> /etc/pacman.conf
USER yaourt
RUN gpg --list-keys && \
	echo 'keyring /etc/pacman.d/gnupg/pubring.gpg' >> ~/.gnupg/gpg.conf
CMD ["make", "yaourt"]