FROM alpine:3.8

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    EDITOR=vim

RUN apk add --no-cache bash bash-completion vim

CMD ["sh", "-c", "tail -f /dev/null"]
