{ pkgs, lib, config, ... }:
let
  cfg = config.customization.services.chatUi;

  # Chat UI package - just install source and dependencies
  chat-ui-pkg = pkgs.buildNpmPackage rec {
    pname = "chat-ui";
    version = "0-unstable-2024-10-01";

    src = pkgs.fetchFromGitHub {
      owner = "huggingface";
      repo = "chat-ui";
      rev = "dbb34920c6f779b4f444fb57d55b4a79c4773f9d";
      hash = "sha256-biYpldpSDi5+G1gJ12ftKbSJ5FL/vuAbKDvNuDJDJSk=";
    };

    # Hash of npm dependencies
    npmDepsHash = "sha256-VFJaFn7K7GvynXSZMrrlMjOigMGiOwFA011sVj85RH4=";

    # Node.js version matching upstream requirements (>=22.1.0)
    nodejs = pkgs.nodejs_22;

    # Don't run build - just install dependencies
    dontNpmBuild = true;

    # Install phase - copy source and install dependencies
    installPhase = ''
      mkdir -p $out/bin $out/share/chat-ui
      cp -r * $out/share/chat-ui/
      cp -r node_modules $out/share/chat-ui/

      # Create startup script
      cat > $out/bin/chat-ui << 'EOF'
      #!/bin/sh
      cd $(dirname $0)/../share/chat-ui
      exec npm run dev
      EOF
      chmod +x $out/bin/chat-ui
    '';

    meta = with lib; {
      description = "HuggingFace Chat UI - A SvelteKit-based chat interface";
      homepage = "https://github.com/huggingface/chat-ui";
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = with maintainers; [ ];
    };
  };

  # Environment file for Chat UI
  envFile = pkgs.writeText "chat-ui.env" ''
    # MongoDB configuration
    MONGODB_URL=${cfg.mongodbUrl}

    # HuggingFace token (optional for local models)
    HF_TOKEN=${cfg.hfToken}

    # Server configuration
    PORT=${toString cfg.port}
    HOST=${cfg.host}

    # Optional: Model configurations
    ${lib.optionalString (cfg.models != null) ''
    MODELS=${builtins.toJSON cfg.models}
    ''}

    # Optional: Text embedding models
    ${lib.optionalString (cfg.textEmbeddingModels != null) ''
    TEXT_EMBEDDING_MODELS=${builtins.toJSON cfg.textEmbeddingModels}
    ''}

    # Optional: Web search configuration
    ${lib.optionalString (cfg.enableWebSearch) ''
    WEBSEARCH_API_PROVIDER=${cfg.webSearchProvider}
    SERPERAPI_KEY=${cfg.serperApiKey}
    SERPAPI_KEY=${cfg.serpApiKey}
    ''}

    # Optional: OpenAI configuration (for custom endpoints)
    ${lib.optionalString (cfg.openaiBaseUrl != null) ''
    OPENAI_BASE_URL=${cfg.openaiBaseUrl}
    ''}
    ${lib.optionalString (cfg.openaiApiKey != null) ''
    OPENAI_API_KEY=${cfg.openaiApiKey}
    ''}
  '';

in {
  options.customization.services.chatUi = {
    enable = lib.mkEnableOption "HuggingFace Chat UI service";

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port on which Chat UI will listen";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host address to bind to";
    };

    mongodbUrl = lib.mkOption {
      type = lib.types.str;
      default = "mongodb://127.0.0.1:27018";
      description = "MongoDB connection URL";
    };

    mongodbPort = lib.mkOption {
      type = lib.types.port;
      default = 27018;
      description = "Port for dedicated MongoDB instance";
    };

    mongodbDbPath = lib.mkOption {
      type = lib.types.str;
      default = "/var/db/mongodb-hf-chat-ui";
      description = "Data directory for dedicated MongoDB instance";
    };

    hfToken = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "HuggingFace access token (optional for local models)";
    };

    models = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.attrs);
      default = null;
      description = "List of model configurations";
      example = lib.literalExpression ''
        [
          {
            id = "meta-llama/Llama-2-70b-chat-hf";
            name = "Llama 2 70B";
            description = "Meta's Llama 2 70B model";
            websiteUrl = "https://huggingface.co/meta-llama/Llama-2-70b-chat-hf";
            datasetName = "meta-llama/Llama-2-70b-chat-hf";
            modelUrl = "https://huggingface.co/meta-llama/Llama-2-70b-chat-hf";
            parameters = {
              temperature = 0.9;
              max_new_tokens = 1024;
              stop = ["</s>"];
            };
            promptTemplate = {
              prefix = "<s>[INST] ";
              suffix = " [/INST]";
            };
          }
        ]
      '';
    };

    textEmbeddingModels = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.attrs);
      default = null;
      description = "List of text embedding model configurations";
    };

    enableWebSearch = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable web search functionality";
    };

    webSearchProvider = lib.mkOption {
      type = lib.types.enum [ "serper" "serpapi" ];
      default = "serper";
      description = "Web search API provider";
    };

    serperApiKey = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Serper API key for web search";
    };

    serpApiKey = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "SerpAPI key for web search";
    };

    openaiBaseUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Custom OpenAI-compatible API base URL";
    };

    openaiApiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "OpenAI API key for custom endpoints";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "chat-ui";
      description = "User account under which Chat UI runs";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "chat-ui";
      description = "Group account under which Chat UI runs";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the configured port in the firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create user and group for Chat UI
    users.users = lib.mkMerge [
      (lib.mkIf (cfg.user == "chat-ui") {
        chat-ui = {
          isSystemUser = true;
          group = cfg.group;
          description = "Chat UI service user";
        };
      })
      {
        mongodb-hf-chat-ui = {
          isSystemUser = true;
          group = "mongodb-hf-chat-ui";
          description = "MongoDB server for Chat UI";
        };
      }
    ];

    users.groups = lib.mkMerge [
      (lib.mkIf (cfg.group == "chat-ui") {
        chat-ui = {};
      })
      {
        mongodb-hf-chat-ui = {};
      }
    ];

    # Dedicated MongoDB service for Chat UI
    systemd.services.mongodb-hf-chat-ui = {
      description = "MongoDB server for HuggingFace Chat UI";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.mongodb}/bin/mongod --config ${pkgs.writeText "mongodb-hf-chat-ui.conf" ''
          net.bindIp: 127.0.0.1
          net.port: ${toString cfg.mongodbPort}
          systemLog.destination: syslog
          systemLog.quiet: true
          storage.dbPath: ${cfg.mongodbDbPath}
        ''} --fork --pidfilepath /run/mongodb-hf-chat-ui.pid";
        User = "mongodb-hf-chat-ui";
        PIDFile = "/run/mongodb-hf-chat-ui.pid";
        Type = "forking";
        TimeoutStartSec = 120;
        PermissionsStartOnly = true;
        Restart = "on-failure";
        RestartSec = 5;
      };

      preStart = ''
        rm -f ${cfg.mongodbDbPath}/mongod.lock || true
        if ! test -e ${cfg.mongodbDbPath}; then
            install -d -m0700 -o mongodb-hf-chat-ui ${cfg.mongodbDbPath}
            touch ${cfg.mongodbDbPath}/.first_startup
        fi
        if ! test -e /run/mongodb-hf-chat-ui.pid; then
            install -D -o mongodb-hf-chat-ui /dev/null /run/mongodb-hf-chat-ui.pid
        fi
      '';

      postStart = ''
        if test -e "${cfg.mongodbDbPath}/.first_startup"; then
          rm -f "${cfg.mongodbDbPath}/.first_startup"
        fi
      '';
    };

    # Add Chat UI package to system packages
    environment.systemPackages = [ chat-ui-pkg ];

    
    # Firewall configuration
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.port ];

    # Systemd service for Chat UI
    systemd.services.chat-ui = {
      description = "HuggingFace Chat UI Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "mongodb-hf-chat-ui.service" ];
      requires = [ "mongodb-hf-chat-ui.service" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = 5;

        # Security settings
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ "/tmp" ];
        NoNewPrivileges = true;

        # Exec configuration
        ExecStart = "${chat-ui-pkg}/bin/chat-ui";
        WorkingDirectory = "${chat-ui-pkg}/share/chat-ui";

        # Environment file
        EnvironmentFile = envFile;

        # Resource limits
        LimitNOFILE = 65536;
      };

      # Environment variables
      environment = {
        NODE_ENV = "production";
        MONGODB_URL = cfg.mongodbUrl;
        HF_TOKEN = cfg.hfToken;
        PORT = toString cfg.port;
        HOST = cfg.host;
      } // lib.optionalAttrs (cfg.openaiBaseUrl != null) {
        OPENAI_BASE_URL = cfg.openaiBaseUrl;
      } // lib.optionalAttrs (cfg.openaiApiKey != null) {
        OPENAI_API_KEY = cfg.openaiApiKey;
      };

      # Pre-start script to verify MongoDB is ready
      preStart = ''
        # Wait for MongoDB to be ready
        echo "Waiting for MongoDB to be ready..."
        for i in {1..30}; do
          if ${pkgs.mongodb}/bin/mongosh --eval "db.adminCommand('ping')" "${cfg.mongodbUrl}" >/dev/null 2>&1; then
            echo "MongoDB is ready"
            break
          fi
          if [ $i -eq 30 ]; then
            echo "MongoDB failed to start after 30 seconds"
            exit 1
          fi
          sleep 1
        done
      '';
    };
  };
}