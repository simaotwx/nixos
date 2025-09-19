{ pkgs, ... }: {
  _module.args.compressorXz = { name, inputFile, compressionLevel }:
    pkgs.runCommand name {
      allowSubstitutes = false;
      dontFixup = true;
      nativeBuildInputs = [ pkgs.xz ];
    } ''
      xz -${toString compressionLevel} -c ${inputFile} > $out
    '';
}