{
  network.description = "HelloWorld";

  helloserver = 
    { config, pkgs, ... }:
    let
      packages = import ./default.nix { inherit pkgs; };
      nodejs   = packages.nodejs;
      app      = packages.app;
    in
    {
      # Let's enable the firewall so that we can forward port 80 to 8080
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 80 8080 22 ];
      networking.firewall.allowPing = true;

      # Port forwarding using iptables
      networking.firewall.extraCommands = ''
        iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
      '';

      # The systemd service that runs our application and keeps it running
      systemd.services.helloserver = {
        description = "Hello world application";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = { PORT = "8080"; };
        serviceConfig = {
          ExecStart = "${nodejs}/bin/node ${app}/server.js";
          User = "nodejs";
          Group = "nodejs";
          Restart = "always";
        };
      };

      users.extraUsers = {
        nodejs = { group = "nodejs"; };
      };

      users.extraGroups = { nodejs = {}; };
    };
}
