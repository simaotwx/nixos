{ lib, pkgs, config, ... }:

let
  dataDir = "/var/lib/librechat";
  mongoDataDir = "/var/lib/librechat-mongo";
  mongoPort = 27038;

  librechatYaml = pkgs.writeText "librechat.yaml" (
    builtins.toJSON {
      version = "1.3.0";
      cache = true;

      endpoints = {
        agents = {
          disableBuilder = true;
        };
        custom = [
          {
            name = "llama_local";
            apiKey = "dummy";
            baseURL = "http://127.0.0.1:11434/v1/";
            models = {
              fetch = true;
              default = [ "local" ];
            };
            titleConvo = true;
            titleModel = "current_model";
            modelDisplayLabel = "Local model";
            addParams = {
              model_identity = "You are GPT-OSS, a model running on local hardware";
            };
            webSearch.searchProvider = "searxng";
          }
        ];
      };

      mcpServers = {
        hello-world = {
          type = "stdio";
          command = lib.getExe (pkgs.python3.withPackages (ps: [ ps.mcp ]));
          args = [
            "${./mcp/hello-world.py}"
          ];
        };
        fortune = {
          type = "stdio";
          command = lib.getExe (
            pkgs.writeShellApplication {
              name = "fortune-mcp";
              runtimeInputs = [
                (pkgs.python3.withPackages (ps: [ ps.mcp ]))
                pkgs.fortune
              ];
              text = ''
                python ${./mcp/fortune.py}
              '';
            }
          );
          args = [ ];
        };
      };

      modelSpecs = {
        enforce = true;
        list = [
          {
            default = true;
            description = "Chatting";
            label = "Chatting";
            name = "chatting";
            preset = {
              endpoint = "llama_local";
              greeting = "";
              model = "local";
              modelLabel = "Local";
              reasoning_effort = "low";
              temperature = 1.0;
              top_p = 0.95;
              top_k = 40;
              #frequency_penalty = 1.0;
              instructions = ''
                You're a helpful assistant. Follow user's instructions strictly and refrain from any kind of flattery.
              '';
            };
          }
        ];
        prioritize = true;
      };
    }
  );

  mongoConf = pkgs.writeText "mongodb-librechat.conf" ''
    net:
      bindIp: 127.0.0.1
      port: ${toString mongoPort}
    systemLog:
      destination: syslog
      quiet: true
    storage:
      dbPath: ${mongoDataDir}
  '';
in
{
  users.users.librechat = {
    isSystemUser = true;
    group = "librechat";
  };
  users.groups.librechat = { };
  users.users.mongodb-librechat = {
    isSystemUser = true;
    group = "mongodb-librechat";
  };
  users.groups.mongodb-librechat = { };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 librechat librechat -"
    "d ${mongoDataDir} 0700 mongodb-librechat mongodb-librechat -"
  ];

  systemd.services.mongodb-librechat = {
    description = "MongoDB for LibreChat";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = "mongodb-librechat";
      Type = "forking";
      PIDFile = "/run/mongodb-librechat.pid";
      PermissionsStartOnly = true;
      TimeoutStartSec = 120;
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "${pkgs.mongodb}/bin/mongod --config ${mongoConf} --fork --pidfilepath /run/mongodb-librechat.pid";
    };
    preStart = ''
      rm -f ${mongoDataDir}/mongod.lock || true
      if ! test -e /run/mongodb-librechat.pid; then
        install -D -o mongodb-librechat /dev/null /run/mongodb-librechat.pid
      fi
    '';
  };

  services.searx = {
    enable = true;
    settings = {
      server = {
        secret_key = lib.fakeSha256;
        port = 8888;
        bind_address = "0.0.0.0";
      };
      search = {
        formats = [ "json" "html" ];
      };
    };
  };

  systemd.services.librechat = {
    description = "LibreChat server";
    after = [
      "mongodb-librechat.service"
    ];
    requires = [ "mongodb-librechat.service" ];
    wantedBy = [ ];
    serviceConfig = {
      User = "librechat";
      Group = "librechat";
      WorkingDirectory = dataDir;
      StateDirectory = "librechat";
      ExecStart = "${pkgs.unstable.librechat}/bin/librechat-server";
      Environment = [
        "HOST=0.0.0.0"
        "PORT=3080"
        "MONGO_URI=mongodb://127.0.0.1:${toString mongoPort}/LibreChat"
        "CONFIG_PATH=${librechatYaml}"
        "DOMAIN_CLIENT=http://localhost:3080"
        "DOMAIN_SERVER=http://localhost:3080"
        "NO_INDEX=true"
        "TRUST_PROXY=1"
        "JWT_SECRET=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        "JWT_REFRESH_SECRET=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        "CREDS_KEY=f34be427ebb29de8d88c107a71546019685ed8b241d8f2ed00c3df97ad2566f0"
        "CREDS_IV=e2341419ec3dd3d19b13a1a87fafcbfb"
        "ALLOW_REGISTRATION=true"
        "ENDPOINTS=custom,agents"
        "SEARXNG_INSTANCE_URL=http://localhost:8888"
        "SEARXNG_API_KEY=${config.services.searx.settings.server.secret_key}"
      ];
      Restart = "on-failure";
    };
  };

  networking.firewall.allowedTCPPorts = [ 3080 8888 ];
}
