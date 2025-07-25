FROM curlimages/curl AS curl

FROM dart:3.8 AS build

# Set the working directory
WORKDIR /app

# Add pubspec.yaml and get dependencies
COPY pubspec.yaml pubspec.yaml
RUN dart pub get --no-precompile

# Copy app source code and refetch dependencies to cache
{{#files}}
COPY '{{source}}' '{{target}}'
{{/files}}
RUN dart pub get --offline --no-precompile

# AOT compile `server.dart` to server executable
RUN dart compile exe server.dart -o server

# Build minimal serving image from AOT-compiled `server` executable
FROM scratch
COPY --from=build /bin/sh /bin/sh

COPY --from=build /runtime/ /
COPY --from=build /app/server /app/server

COPY --from=curl /usr/bin/curl curl
HEALTHCHECK CMD curl --fail http://0.0.0.0:3000 || exit 1

ENTRYPOINT {{command}}
