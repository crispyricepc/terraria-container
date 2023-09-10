FROM docker.io/library/debian:12-slim

# Explicitly list all DLL files found in the terraria zip file
# lots of these are probably included as dependencies of mono-runtime,
# but listing them explicitly will do nothing bad in this case
# only missing library is (maybe) FNA3D, which doesn't seem to be shipped in debian
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates unzip \
    mono-runtime \
    libmono-posix4.0-cil \
    libmono-security4.0-cil \
    libmono-system-configuration4.0-cil \
    libmono-system-core4.0-cil \
    libmono-system-data4.0-cil \
    libmono-system4.0-cil \
    libmono-system-drawing4.0-cil \
    libmono-system-numerics4.0-cil \
    libmono-system-runtime-serialization4.0-cil \
    libmono-system-security4.0-cil \
    libmono-system-windows-forms4.0-cil \
    libmono-system-xml4.0-cil \
    libmono-system-xml-linq4.0-cil \
    libmono-windowsbase4.0-cil \
    libsdl2-2.0 \
    libfaudio0 \
    libsdl2-image-2.0

RUN wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip -O /terraria-1449.zip &&\
    unzip /terraria-1449.zip -d /tmp/terraria &&\
    rm /terraria-1449.zip

RUN mkdir -p /opt/terraria &&\
    cp /tmp/terraria/1449/Linux/TerrariaServer.exe /opt/terraria &&\
    cp /tmp/terraria/1449/Linux/FNA.dll /opt/terraria


CMD /usr/bin/mono --server --gc=sgen -O=all /opt/terraria/TerrariaServer.exe -config /config.txt
