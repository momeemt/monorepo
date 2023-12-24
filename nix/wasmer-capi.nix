{ stdenv, lib, fetchFromGitHub, makeWrapper, gnumake, cargo, rustc, nodejs_20, pkg-config, openssl, libiconv, libffi, darwin }:

stdenv.mkDerivation rec {
  pname = "wasmer-capi";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wasmer";
    rev = "v${version}";
    sha256 = "GROw9TYKC53ECJUeYhCez8f2jImPla/lGgsP91tTGjQ=";
  };

  nativeBuildInputs = [ makeWrapper gnumake cargo rustc nodejs_20 pkg-config libiconv ];
  buildInputs = [ openssl libffi ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security ]);

  cargoHash = "sha256-JE7FDF4MWhqJbL7ZP+yzfV7/Z79x0NuQLYNwWwMjAao=";

  buildPhase = ''
    export CARGO_HOME=$(mktemp -d)
    make build-capi
  '';

  installPhase = ''
    mkdir -p $out/
    make package-capi
    cp -r package/* $out/
  '';

  meta = with lib; {
    description = "Wasmer - The Universal WebAssembly Runtime";
    homepage = "https://wasmer.io/";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
