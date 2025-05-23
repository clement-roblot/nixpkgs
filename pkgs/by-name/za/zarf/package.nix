{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "zarf";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "defenseunicorns";
    repo = "zarf";
    rev = "v${version}";
    hash = "sha256-rY9xWqJ+2Yfs6VRHTF89LmuEruAavDI7MgBm4UFEuBs=";
  };

  vendorHash = "sha256-Cz+w0tOEamCxf61hvQ03X/kXPY+qrmdBN8s26lr/wZ8=";
  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    mkdir -p build/ui
    touch build/ui/index.html
  '';

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/defenseunicorns/zarf/src/config.CLIVersion=${src.rev}"
    "-X"
    "k8s.io/component-base/version.gitVersion=v0.0.0+zarf${src.rev}"
    "-X"
    "k8s.io/component-base/version.gitCommit=${src.rev}"
    "-X"
    "k8s.io/component-base/version.buildDate=1970-01-01T00:00:00Z"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export K9S_LOGS_DIR=$(mktemp -d)
    installShellCompletion --cmd zarf \
      --bash <($out/bin/zarf completion --no-log-file bash) \
      --fish <($out/bin/zarf completion --no-log-file fish) \
      --zsh  <($out/bin/zarf completion --no-log-file zsh)
  '';

  meta = with lib; {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    mainProgram = "zarf";
    homepage = "https://github.com/defenseunicorns/zarf.git";
    license = licenses.asl20;
    maintainers = with maintainers; [ ragingpastry ];
  };
}
