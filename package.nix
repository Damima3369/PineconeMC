{ lib
, appimageTools
, fetchurl
, symlinkJoin
, makeWrapper
, stdenv
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
, xorg
, pciutils
}:

let
  pname = "pineconemc"; 
  version = "11.0.3"; # UPDATE_VERSION

  sources = {
    x86_64-linux = {
      url = "https://github.com/ElyPrismLauncher/Launcher/releases/download/11.0.3/PineconeMC-Linux-x86_64.AppImage"; # UPDATE_URL_X86
      hash = "sha256-17f9fzxspszm7rrnlz5z1ix20x4bjs7zfpr3k0g4kqalwpym4m5b"; # UPDATE_HASH_X86
    };
    aarch64-linux = {
      url = "https://github.com/ElyPrismLauncher/Launcher/releases/download/11.0.3/PineconeMC-Linux-aarch64.AppImage"; # UPDATE_URL_ARM
      hash = "sha256-082as01vklb56lqcxpzal8xhvklah8x3s38mp1nam5rwm7xmhsfz"; # UPDATE_HASH_ARM
    };
  };

  system = stdenv.hostPlatform.system;
  selectedSource = sources.${system} or (throw "Архитектура ${system} не поддерживается этим пакетом");

  jdks = [ jdk25 jdk21 jdk17 jdk8 ];

  appimage = appimageTools.wrapType2 {
    inherit pname version;

    src = fetchurl {
      url = selectedSource.url;
      hash = selectedSource.hash;
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
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXrandr
      xorg.libXxf86vm
      xorg.xrandr
    ];
  };
in
symlinkJoin {
  name = "${pname}-${version}";
  paths = [ appimage ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    # Прописываем пути к Java[cite: 1]
    wrapProgram $out/bin/${pname} \
      --prefix PRISMLAUNCHER_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}

    # Копируем созданный ярлык в структуру пакета
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with lib; {
    description = "This fork of Prism Launcher adds integrated support for Ely.by accounts.";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = pname;
  };
}