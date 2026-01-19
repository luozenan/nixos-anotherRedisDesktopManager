# pkgs/by-name/ap/apifox/package.nix（完全对齐微信写法）
{ pkgs, lib, ... }:

let
  pname = "anotherRedisDesktopManager";
  version = "1.7.1";

  src = fetchurl {
          url = "https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v1.7.1/Another-Redis-Desktop-Manager-linux-1.7.1-x86_64.AppImage";
          hash = "sha256-+r5Ebu40GVGG2m2lmCFQ/JkiDsN/u7XEtnLrB98602w=";
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
    license = licenses.MIT;
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
