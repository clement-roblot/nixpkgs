{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  gtk3,
  gnome,
  adwaita-icon-theme,
  gdk-pixbuf,
  librsvg,
  wrapGAppsHook3,
  itstool,
  gsound,
  libxml2,
  meson,
  ninja,
  python3,
  vala,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "iagno";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${lib.versions.majorMinor version}/iagno-${version}.tar.xz";
    hash = "sha256-hLnzLOA4l1iiHWPH6xwifbcRa1HTFJqg6uNQkWjg7SQ=";
  };

  patches = [
    # Fix build with recent Vala.
    # https://gitlab.gnome.org/GNOME/dconf-editor/-/merge_requests/15
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/iagno/-/commit/e8a0aeec350ea80349582142c0e8e3cd3f1bce38.patch";
      hash = "sha256-OO1x0Yx56UFzHTBsPAMYAjnJHlnTjdO1Vk7q6XU8wKQ=";
    })
    # https://gitlab.gnome.org/GNOME/dconf-editor/-/merge_requests/13
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/iagno/-/commit/508c0f94e5f182e50ff61be6e04f72574dee97cb.patch";
      hash = "sha256-U7djuMhb1XJaKAPyogQjaunOkbBK24r25YD7BgH05P4=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    python3
    vala
    desktop-file-utils
    pkg-config
    wrapGAppsHook3
    itstool
    libxml2
  ];

  buildInputs = [
    gtk3
    adwaita-icon-theme
    gdk-pixbuf
    librsvg
    gsound
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "iagno"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/iagno";
    description = "Computer version of the game Reversi, more popularly called Othello";
    mainProgram = "iagno";
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
