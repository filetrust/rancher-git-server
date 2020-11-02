FROM nginx:alpine

RUN set -x && \
  apk --update upgrade                                  &&  \
  apk add git bash fcgiwrap spawn-fcgi wget sudo su-exec git-daemon           &&  \
  adduser git -h /var/lib/git -D                        &&  \
  adduser nginx git                                     &&  \
  echo "git ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-git-user      &&  \
  git config --system http.receivepack true             &&  \
  git config --system http.uploadpack true              &&  \
  git config --system user.email "gitserver@git.com"    &&  \
  git config --system user.name "Rancher Git Server"    &&  \
  ln -sf /dev/stdout /var/log/nginx/access.log          &&  \
  ln -sf /dev/stderr /var/log/nginx/error.log

ADD etc /etc
ADD entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "entrypoint" ]
CMD [ "-start" ]

