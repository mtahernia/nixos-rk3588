{
  lib,
  pkgs,
  ...
}:
let
  username = "mehrdad";
  # To generate a hashed password run `mkpasswd -m scrypt`.
  # this is the hash of the password "rk3588"
  hashedPassword = "$y$j9T$DFwrh.VfDjva9Bam/wdq51$.Md0WSSV4xMIlqj8qiZL5c03k/8fnc1vIRSSziGJEf/";
in
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git # used by nix flakes
    curl

    neofetch
    lm_sensors # `sensors`
    btop # monitor system resources

    # Peripherals
    mtdutils
    i2c-tools
    minicom
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      X11Forwarding = lib.mkDefault true;
      PasswordAuthentication = lib.mkDefault true;
    };
    openFirewall = lib.mkDefault true;
  };

  # =========================================================================
  #      Users & Groups NixOS Configuration
  # =========================================================================

  # TODO Define a user account. Don't forget to update this!
  users.users."${username}" = {
    inherit hashedPassword;
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [
      "users"
      "wheel"
    ];
  };

  system.stateVersion = "24.11";
}
