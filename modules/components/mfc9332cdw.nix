{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, coreutils
, gnugrep
, gnused
, mfc9332cdwlpr
, pkgsi686Linux
, psutils
, patchelf
}:

stdenv.mkDerivation rec {
  pname = "mfc9332cdwcupswrapper";
  version = "1.1.4-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101621/${pname}-${version}.i386.deb";
    hash = "sha256-vGSEWzZ+ga2RQe8DjGgJbkv7wzp2i4n5B4i+3CBIPuE=";
  };

  unpackPhase = ''
    dpkg-deb -x "$src" "$out"
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
    patchelf
  ];

  dontBuild = true;

  installPhase = ''
    lpr=${mfc9332cdwlpr}/opt/brother/Printers/mfc9332cdw
    dir=$out/opt/brother/Printers/mfc9332cdw

    interpreter=${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" "$dir/cupswrapper/brcupsconfpt1"

    substituteInPlace "$dir/cupswrapper/cupswrappermfc9332cdw" \
      --replace "mkdir -p /usr" ": # mkdir -p /usr" \
      --replace '/opt/brother/''${device_model}/''${printer_model}/lpd/filter''${printer_model}' "$lpr/lpd/filtermfc9332cdw" \
      --replace '/usr/share/ppd/Brother/brother_''${printer_model}_printer_en.ppd' "$dir/cupswrapper/brother_mfc9332cdw_printer_en.ppd" \
      --replace '/usr/share/cups/model/Brother/brother_''${printer_model}_printer_en.ppd' "$dir/cupswrapper/brother_mfc9332cdw_printer_en.ppd" \
      --replace '/opt/brother/Printers/''${printer_model}/' "$lpr/" \
      --replace 'nup="psnup' "nup=\"${psutils}/bin/psnup" \
      --replace '/usr/bin/psnup' "${psutils}/bin/psnup"

    mkdir -p "$out/lib/cups/filter" "$out/share/cups/model"

    ln "$dir/cupswrapper/cupswrappermfc9332cdw" "$out/lib/cups/filter"
    ln "$dir/cupswrapper/brother_mfc9332cdw_printer_en.ppd" "$out/share/cups/model"

    sed -n '/!ENDOFWFILTER!/,/!ENDOFWFILTER!/p' "$dir/cupswrapper/cupswrappermfc9332cdw" \
      | sed '1 br; b; :r s/.*/printer_model=mfc9332cdw; cat <<!ENDOFWFILTER!/' \
      | bash > "$out/lib/cups/filter/brother_lpdwrapper_mfc9332cdw"

    sed -i "/#! \/bin\/sh/a PATH=${
      lib.makeBinPath [ coreutils gnused gnugrep ]
    }:\$PATH" "$out/lib/cups/filter/brother_lpdwrapper_mfc9332cdw"

    chmod +x "$out/lib/cups/filter/brother_lpdwrapper_mfc9332cdw"
  '';

  meta = with lib; {
    description = "Brother MFC-9332CDW CUPS wrapper driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexa ];
  };
}
