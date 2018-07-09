FROM openjdk:8-jdk

MAINTAINER Francesco Corbi <francesco.corbi92@gmail.com>

ENV ANDROID_COMPILE_SDK="27" \
    ANDROID_BUILD_TOOLS="27.0.3" \
    ANDROID_SDK_TOOLS_REV="3859397" \
    ANDROID_CMAKE_REV="3.6.4111459"

ENV ANDROID_HOME=/opt/android-sdk-linux
ENV ANDROID_SDK_ROOT=/opt/android-sdk-linux

ENV PATH ${PATH}:${ANDROID_HOME}/platform-tools/:${ANDROID_NDK_HOME}:${ANDROID_HOME}/ndk-bundle:${ANDROID_HOME}/tools/bin/

# RUN apt-get update &&\
#     apt-get install -y software-properties-common &&\
#     add-apt-repository ppa:ubuntu-sdk-team/ppa &&\
#     apt-get install -y libqt5widgets5

RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz &&\
    mkdir -p /usr/local/gcloud &&\
    tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz &&\
    /usr/local/gcloud/google-cloud-sdk/install.sh

ENV PATH ${PATH}:/usr/local/gcloud/google-cloud-sdk/bin

RUN    mkdir -p ${ANDROID_HOME} \
    && wget --quiet --output-document=${ANDROID_HOME}/android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_REV}.zip \
    && unzip -qq ${ANDROID_HOME}/android-sdk.zip -d ${ANDROID_HOME} \
    && rm ${ANDROID_HOME}/android-sdk.zip \
    && mkdir -p $HOME/.android \
    && echo 'count=0' > $HOME/.android/repositories.cfg

RUN    yes | sdkmanager --licenses > /dev/null \ 
    && yes | sdkmanager --update \
    && yes | sdkmanager 'tools' \
    && yes | sdkmanager 'platform-tools' \
    && yes | sdkmanager 'build-tools;'$ANDROID_BUILD_TOOLS \
    && yes | sdkmanager 'platforms;android-'$ANDROID_COMPILE_SDK \
    && yes | sdkmanager 'extras;android;m2repository' \
    && yes | sdkmanager 'extras;google;google_play_services' \
    && yes | sdkmanager 'extras;google;m2repository' 

RUN    yes | sdkmanager 'cmake;'$ANDROID_CMAKE_REV \
    && yes | sdkmanager 'ndk-bundle' 
