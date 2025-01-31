{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, ninja
, jdk8
, jdk
, zlib
, file
, makeWrapper
, xorg
, libpulseaudio
, qtbase
, libGL
, msaClientID ? ""

# flake
, self
, submoduleNbt
, submoduleQuazip
}:

let
  # Libraries required to run Minecraft
  libpath = with xorg; lib.makeLibraryPath [
    libX11
    libXext
    libXcursor
    libXrandr
    libXxf86vm
    libpulseaudio
    libGL
  ];

  # This variable will be passed to Minecraft by SneedMC
  gameLibraryPath = libpath + ":/run/opengl-driver/lib";
in

mkDerivation rec {
  pname = "sneedmc";
  version = "nightly";

  src = lib.cleanSource self;

  nativeBuildInputs = [ cmake ninja file makeWrapper ];
  buildInputs = [ qtbase jdk8 zlib ];

  dontWrapQtApps = true;

  postPatch = ''
    # hardcode jdk paths
    substituteInPlace launcher/java/JavaUtils.cpp \
      --replace 'scanJavaDir("/usr/lib/jvm")' 'javas.append("${jdk}/lib/openjdk/bin/java")' \
      --replace 'scanJavaDir("/usr/lib32/jvm")' 'javas.append("${jdk8}/lib/openjdk/bin/java")'
  '' + lib.optionalString (msaClientID != "") ''
    # add client ID
    substituteInPlace CMakeLists.txt \
      --replace '17b47edd-c884-4997-926d-9e7f9a6b4647' '${msaClientID}'
  '';

  postUnpack = ''
    # Copy submodules inputs
    rm -rf source/libraries/{libnbtplusplus,quazip}
    mkdir source/libraries/{libnbtplusplus,quazip}
    cp -a ${submoduleNbt}/* source/libraries/libnbtplusplus
    cp -a ${submoduleQuazip}/* source/libraries/quazip
    chmod a+r+w source/libraries/{libnbtplusplus,quazip}/*
  '';

  cmakeFlags = [
    "-GNinja"
    "-DLauncher_LAYOUT=lin-system"
  ];

  postInstall = ''
    # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
    wrapProgram $out/bin/sneedmc \
      "''${qtWrapperArgs[@]}" \
      --set GAME_LIBRARY_PATH ${gameLibraryPath} \
      --prefix PATH : ${lib.makeBinPath [ xorg.xrandr ]}
  '';

  meta = with lib; {
    homepage = "https://sneedmc.org/";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ starcraft66 kloenk ];
  };
}
