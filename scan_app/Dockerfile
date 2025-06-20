FROM debian:bullseye


RUN apt-get update && apt-get install -y \
  git curl unzip xz-utils zip libglu1-mesa openjdk-11-jdk wget bash sudo


RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"


RUN flutter channel stable && flutter upgrade && flutter config --enable-web


WORKDIR /app


COPY . .


RUN flutter pub get



CMD ["flutter", "run", "-d", "chrome"]
