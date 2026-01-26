官方网站：https://goanother.com/cn/

nixos-anotherRedisDesktopManager

electerm for nixos

install:
flake inputs:

###
 anotherRedisDesktopManager-github = {
 
    url = "github:luozenan/nixos-anotherRedisDesktopManager";
    
    inputs.nixpkgs.follows = "nixpkgs";
  }; 
###

###
environment.systemPackages = [

     inputs.anotherRedisDesktopManager-github.packages.${pkgs.stdenv.hostPlatform.system}.another-redis-desktop-manager
     
 ]
###
 
