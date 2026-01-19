# pkgs/by-name/ap/apifox/package.nix（完全对齐微信写法）
{ pkgs, lib, fetchurl, ... }:

let
  pname = "anotherRedisDesktopManager";
  version = "1.7.1";

src = fetchurl {
  url = "https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v1.7.1/Another-Redis-Desktop-Manager-linux-1.7.1-x86_64.AppImage";
  # 替换为真实的sha256 hash（带sha256-前缀）
  hash = "sha256-1n89y09z8x7w6v5u4t3s2r1e0w9q8p7o6i5u4y3x2w1q0a9s8d7f6g5h4j3k2l1m0n9b8v7c6x5s4d3f2g1h0j9k8l7m6n5b4v3c2x1s0d9f8g7h6j5k4l3m2n1b0v9c8x7s6d5f4g3h2j1k0l9m8n7b6v5c4x3s2d1f0g9h8j7k6l5m4n3b2v1c0x9s8d7f6g5h4j3k2l1m0=";
};

  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };

in
# 4. 核心：使用wrapAppImage（和微信的wrapAppImage完全一致）
pkgs.appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents; # 传入解压后的AppImage内容
  meta = with lib; {
    description = "redis desktop manager";
    homepage = "https://github.com/qishibo/AnotherRedisDesktopManager";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };

  # 5. 关键：和微信一样用extraInstallCommands（追加安装操作）
  extraInstallCommands = ''
    # 复制桌面文件（和微信的cp wechat.desktop逻辑一致）
    mkdir -p $out/share/applications
    cp ${appimageContents}/anotherRedisDesktopManager.desktop $out/share/applications/

    # 复制图标（和微信的cp wechat.png逻辑一致，仅尺寸不同）
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${appimageContents}/usr/share/icons/hicolor/256x256/apps/anotherRedisDesktopManager.png $out/share/icons/hicolor/256x256/apps/

    # 替换Exec字段（和微信的--replace-fail AppRun wechat逻辑一致）
    substituteInPlace $out/share/applications/anotherRedisDesktopManager.desktop --replace-fail AppRun anotherRedisDesktopManager
  '';

}
