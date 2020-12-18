self: super:
{
  tmux = super.tmux.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "tmux";
      repo = "tmux";
      rev = "3.2-rc";
      sha256 = "0h4wpdjdspgr3c9i8l6hjyc488dqm60j3vaqzznvxqfjzzf3s7dg";
    };
  });
}
