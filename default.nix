let
   pkgs = import <nixpkgs> {};

   inherit (pkgs.nodePackages) importGeneratedPackages buildNodePackage;

   deps = importGeneratedPackages (import ./node-packages-generated.nix) {} deps;
in {
  app = buildNodePackage {
    name = "application";

    src = { name = "application"; outPath = builtins.filterSource (name: type:
      baseNameOf name != ".git" &&
      baseNameOf name != "node_modules"
    ) ./.; };

    deps = [ deps.request ];

    PORT = "8888";
  };
}
