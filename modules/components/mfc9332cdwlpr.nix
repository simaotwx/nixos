{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, perl
, coreutils
, file
, ghostscript
, gnugrep
, gnused
, which
, pkgs
, patchelf
}:

stdenv.mkDerivation rec {
  pname = "mfc9332cdwlpr";
  version = "1.1.3-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101620/${pname}-${version}.i386.deb";
    hash = "sha256-irE272qZ96u27jH3UhjCm6AqRanbwq4wFL0Rvi5nuFY=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    patchelf
  ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x "$src" "$out"

    dir=$out/opt/brother/Printers/mfc9332cdw
    filter=$dir/lpd/filtermfc9332cdw

    substituteInPlace "$filter" \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfc9332cdw\"; #"

    wrapProgram "$filter" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          file
          ghostscript
          gnugrep
          gnused
          which
        ]
      }

    interpreter=${pkgs.pkgsi686Linux.glibc}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" "$dir/lpd/brmfc9332cdwfilter"
  '';

  meta = with lib; {
    description = "Brother MFC-9332CDW LPR printer driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
