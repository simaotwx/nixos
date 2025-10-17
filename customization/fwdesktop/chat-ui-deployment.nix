{ lib, pkgs, ... }:

let
  workDir        = "/var/lib/chat-ui";
  mongoDataDir   = "${workDir}/mongo";
  chatUiDataDir  = "${workDir}/chat-ui";

  mongoUser      = "root";
  mongoPass      = "example";
  mongoHost      = "mongo";
  mongoPort      = "27017";
  mongoAuthDB    = "admin"; # root user lives here
  chatUiMongoUri = "mongodb://${mongoUser}:${mongoPass}@${mongoHost}:${mongoPort}/?authSource=${mongoAuthDB}";

  dockerCompose = pkgs.writeText "docker-compose.yml" (builtins.toJSON {
    services = {
      mongo = {
        image = "mongo";
        restart = "no";
        environment = {
          MONGO_INITDB_ROOT_USERNAME = mongoUser;
          MONGO_INITDB_ROOT_PASSWORD = mongoPass;
        };
        volumes = [ "${mongoDataDir}:/data/db" ];
        networks = [ "appnet" ];
      };

      chat-ui = {
        image = "ghcr.io/huggingface/chat-ui:latest";
        restart = "no";
        depends_on = [ "mongo" ];
        ports = [ "3000:3000" ];
        environment = {
          MONGODB_URL     = chatUiMongoUri;
          OPENAI_BASE_URL = "http://host.docker.internal:11434/v1";
          OPENAI_API_KEY  = "ollama";
          PUBLIC_ORIGIN = "http://localhost:3000";
          ALLOW_INSECURE_COOKIES = "true";
          USE_LOCAL_WEBSEARCH = "true";
        };
        volumes = [ "${chatUiDataDir}:/data" ];
        networks = [ "appnet" ];
        extra_hosts = [ "host.docker.internal:host-gateway" ];
      };
    };
    networks = { appnet = {}; };
  });
in
{
  virtualisation.docker.enable = true;

  systemd.tmpfiles.rules = [
    "d ${workDir} 0755 root root -"
    "d ${mongoDataDir} 0755 root root -"
    "d ${chatUiDataDir} 0755 root root -"
  ];

  systemd.services.chat-ui-stack = {
    description = "Chat UI + Mongo stack (docker compose)";
    requires = [ "docker.service" ];
    after    = [ "docker.service" ];
    serviceConfig = {
      Type = "simple";
      Restart = "no";
      User = "root";
      Group = "docker";
      WorkingDirectory = workDir;
      ExecStart = "${lib.getExe pkgs.docker} compose -f ${dockerCompose} up";
      ExecStop  = "${lib.getExe pkgs.docker} compose -f ${dockerCompose} down";
      TimeoutStartSec = 3600;
    };
  };
}
