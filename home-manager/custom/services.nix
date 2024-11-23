{ config, lib, pkgs, ... }:

with lib;

let
  srvPrefix = "hm-"; # Home Manager
  conSrvPrefix = "hmc-"; # Home Manager Container
  ociCmd = config.custom.ociCmd;
  serviceConfig = { enable, desc, startCmd, stopCmd, ... }: mkIf enable {
    Unit.Description = "${desc}";
    Unit.After = [ "network.target" ];
    Install.WantedBy = [ "default.target" ];
    Service = {
      ExecStart = "${startCmd}";
      ExecStop = "${stopCmd}";
      Restart = "on-failure";
    };
  };

  containerConfig = { enable, name, params, ... }:
    let cName = "${conSrvPrefix}${name}"; in
    mkIf enable {
      Unit.Description = "${cName} container";
      Unit.After = [ "network.target" ];
      Install.WantedBy = [ "default.target" ];
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
    custom.services.podman.enable = mkEnableOption "Podman service";
    custom.containers = {
      mariadb.enable = mkEnableOption "MariaDB container";
      gotify.enable = mkEnableOption "Gotify container";
      clickhouse.enable = mkEnableOption "ClickHouse container";
      ddns-go.enable = mkEnableOption "DDNS-Go container";
    };
  };

  config = {
    systemd.user.services = {
      "${srvPrefix}podman" = serviceConfig {
        enable = config.custom.services.podman.enable;
        desc = "Podman service";
        startCmd = "/usr/bin/podman system service --time 0";
        stopCmd = "";
      };

      "${conSrvPrefix}mariadb" = containerConfig {
        enable = config.custom.containers.mariadb.enable;
        name = "mariadb";
        params = ''
          -e MYSQL_ROOT_PASSWORD=root \
          -p 127.0.0.1:3306:3306 \
          -v mariadb_data:/var/lib/mysql \
          mariadb
        '';
      };

      "${conSrvPrefix}gotify" = containerConfig {
        enable = config.custom.containers.gotify.enable;
        name = "gotify";
        params = ''
          -p 7777:80 \
          -v gotify-data:/app/data \
          gotify/server
        '';
      };

      "${conSrvPrefix}clickhouse" = containerConfig {
        enable = config.custom.containers.clickhouse.enable;
        name = "clickhouse";
        params = ''
          -p 127.0.0.1:8123:8123 \
          -p 127.0.0.1:9000:9000 \
          -v ch_data:/var/lib/clickhouse \
          -v ch_config:/etc/clickhouse-server \
          -v ch_logs:/var/log/clickhouse-server \
          clickhouse/clickhouse-server
        '';
      };

      "${conSrvPrefix}ddns-go" = containerConfig {
        enable = config.custom.containers.ddns-go.enable;
        name = "ddns-go";
        params = ''
          --network host \
          -v ddns-go-data:/root \
          jeessy/ddns-go
        '';
      };
    };
  };
}
