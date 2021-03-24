self: super:
{
  vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };


  vimPlugins = super.vimPlugins // super.callPackage ./vimPlugins.nix { };
}
