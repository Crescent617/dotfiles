{ config, lib, pkgs, ... }:

with lib;

let
  prefix = "hm-"; # Home Manager
  ociCmd = config.custom.ociCmd;
  serviceConfig = { enable, desc, startCmd, stopCmd, autoStart, ... }: mkIf enable {
    Unit.Description = "${desc}";
    Unit.After = [ "network.target" ];
    Install.WantedBy = if autoStart then [ "default.target" ] else [ ];
    Service = {
      ExecStart = "${startCmd}";
      ExecStop = "${stopCmd}";
      Restart = "on-failure";
    };
  };

  containerConfig = { enable, name, params, autoStart, ... }:
    let cName = "${prefix}${name}"; in
    mkIf enable {
      Unit.Description = "${cName} container";
      Unit.After = [ "network.target" ];
      Install.WantedBy = if autoStart then [ "default.target" ] else [ ];
      Service = {
        ExecStartPre = "${ociCmd} rm --ignore ${name}";
        ExecStart = "${ociCmd} run --name ${cName} --rm ${params}";
        ExecStop = "${ociCmd} stop -t 30 ${cName}";
        ExecStopPost = "${ociCmd} rm --ignore ${cName}";
        Restart = "on-failure";
      };
    };
in
{
  options = {
    custom.ociCmd = mkOption {
      type = types.str;
      default = "podman";
      description = "OCI command to use";
    };
    custom.systemd.podman.enable = mkEnableOption "Podman service";
    custom.systemd = {
      mariadb.enable = mkEnableOption "MariaDB container";
      gotify.enable = mkEnableOption "Gotify container";
      clickhouse.enable = mkEnableOption "ClickHouse container";
      ddns-go.enable = mkEnableOption "DDNS-Go container";
      samba.enable = mkEnableOption "Samba container";
    };
  };

  config = {
    systemd.user.services = {
      "${prefix}podman" = serviceConfig {
        enable = config.custom.systemd.podman.enable;
        desc = "Podman service";
        startCmd = "/usr/bin/podman system service --time 0";
        stopCmd = "";
        autoStart = true;
      };

      "${prefix}mariadb" = containerConfig {
        enable = config.custom.systemd.mariadb.enable;
        name = "mariadb";
        params = ''
          -e MYSQL_ROOT_PASSWORD=root \
          -p 127.0.0.1:3306:3306 \
          -v mariadb_data:/var/lib/mysql \
          mariadb
        '';
        autoStart = true;
      };

      "${prefix}gotify" = containerConfig {
        enable = config.custom.systemd.gotify.enable;
        name = "gotify";
        params = ''
          -p 7777:80 \
          -v gotify-data:/app/data \
          gotify/server
        '';
        autoStart = true;
      };

      "${prefix}clickhouse" = containerConfig {
        enable = config.custom.systemd.clickhouse.enable;
        name = "clickhouse";
        params = ''
          -p 127.0.0.1:8123:8123 \
          -p 127.0.0.1:9000:9000 \
          -v ch_data:/var/lib/clickhouse \
          -v ch_config:/etc/clickhouse-server \
          -v ch_logs:/var/log/clickhouse-server \
          -v ch_backups:/backups \
          clickhouse/clickhouse-server
        '';
        autoStart = false;
      };

      "${prefix}ddns-go" = containerConfig {
        enable = config.custom.systemd.ddns-go.enable;
        name = "ddns-go";
        params = ''
          --network host \
          -v ddns-go-data:/root \
          jeessy/ddns-go
        '';
        autoStart = true;
      };

      "${prefix}samba" = containerConfig {
        enable = config.custom.systemd.samba.enable;
        name = "samba";
        params = ''
          -p 1445:445 -e "USER=smbuser" -e 'PASS=123465!' -v samba_data:/storage \
          dockurr/samba
        '';
        autoStart = true;
      };
    };
  };
}
