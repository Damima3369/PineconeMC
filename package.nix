{ lib
, appimageTools
, fetchurl
, symlinkJoin
, makeWrapper
, stdenv
, makeDesktopItem
, jdk8
, jdk17
, jdk21
, jdk25
, libGL
, vulkan-loader
, glfw3-minecraft
, openal
, alsa-lib
, libpulseaudio
, pipewire
, udev
, libx11
, libxcursor
, libxext
, libxrandr
, libxxf86vm
, xrandr
, pciutils
}:

let
  pname = "pineconemc"; 
  version = "11.1.0"; # UPDATE_VERSION

  sources = {
    x86_64-linux = {
      url = "https://github.com/ElyPrismLauncher/Launcher/releases/download/11.1.0/PineconeMC-Linux-x86_64.AppImage"; # UPDATE_URL_X86
      hash = "sha256-n4Znr9N9CPMH6d4eS2AfV5HVPNIXFD1nr+RCrT6wMhY="; # UPDATE_HASH_X86
    };
    aarch64-linux = {
      url = "https://github.com/ElyPrismLauncher/Launcher/releases/download/11.1.0/PineconeMC-Linux-aarch64.AppImage"; # UPDATE_URL_ARM
      hash = "sha256-g49zU4Pngh2HOjBEYQhME/JF6b0pc6onqBtiRkldKfY="; # UPDATE_HASH_ARM
    };
  };

  system = stdenv.hostPlatform.system;
  selectedSource = sources.${system} or (throw "Архитектура ${system} не поддерживается этим пакетом");

  jdks = [ jdk25 jdk21 jdk17 jdk8 ];

  appimageContents = appimageTools.extractType2 {
    inherit pname version;
    src = fetchurl {
      url = selectedSource.url;
      sha256 = selectedSource.hash;
    };
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname; # Указываем имя иконки (согласуется с именем файла ниже, без расширения)
    comment = "PineconeMC";
    desktopName = "PineconeMC";
    categories = [ "Game" ];
  };

  appimage = appimageTools.wrapType2 {
    inherit pname version;
    src = fetchurl {
      url = selectedSource.url;
      sha256 = selectedSource.hash;
    };
    extraPkgs = pkgs: with pkgs; [
      libGL
      vulkan-loader
      glfw3-minecraft
      openal
      udev
      pciutils
      alsa-lib
      libpulseaudio
      pipewire
      libx11
      libxcursor
      libxext
      libxrandr
      libxxf86vm
      xrandr
    ];
  };
in
symlinkJoin {
  name = "${pname}-${version}";
  paths = [ appimage ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/${pname} \
      --prefix PRISMLAUNCHER_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/

    mkdir -p $out/share/icons/hicolor/256x256/apps
    
    cp -L ${appimageContents}/.DirIcon $out/share/icons/hicolor/256x256/apps/${pname}.png
  '';

  meta = with lib; {
    description = "A fork of Prism Launcher with integrated Ely.by account support.";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = pname;
  };
}