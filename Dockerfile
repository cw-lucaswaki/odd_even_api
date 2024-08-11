# Dockerfile
FROM elixir:1.14 AS build

# Install build dependencies
RUN apt-get update && apt-get install -y build-essential git

# Prepare build dir
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build ENV
ENV MIX_ENV=prod

# Install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Compile and build release
COPY lib lib
COPY priv priv
RUN mix compile
RUN mix phx.digest
RUN mix release

# App stage
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y openssl libncurses5 locales \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /app

RUN chown nobody:nogroup /app

USER nobody:nogroup

COPY --from=build --chown=nobody:nogroup /app/_build/prod/rel/odd_even_api ./

ENV HOME=/app

CMD ["bin/odd_even_api", "start"]