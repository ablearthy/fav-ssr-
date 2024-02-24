pkgs:

let
  ocamlPackages = pkgs.coq.ocamlPackages;
  defaultVersion = "2.1.2";
  location = { domain = "github.com"; owner = "coq-community"; repo = "vscoq"; };
  fetch = pkgs.coqPackages.metaFetch ({
    release."2.1.2".sha256 = "sha256-GloY68fLmIv3oiEGNWwmgKv1CMAReBuXzMTUsKOs328=";
    release."2.1.2".rev = "v2.1.2";
    inherit location;
  });
  fetched = fetch defaultVersion;
in
ocamlPackages.buildDunePackage {
  pname = "vscoq-language-server";
  inherit (fetched) version;
  src = "${fetched.src}/language-server";
  nativeBuildInputs = [ pkgs.coq ];
  buildInputs =
    [ pkgs.coq pkgs.glib pkgs.gnome.adwaita-icon-theme pkgs.wrapGAppsHook ] ++
    (with ocamlPackages; [
      findlib
      lablgtk3-sourceview3
      yojson
      zarith
      ppx_inline_test
      ppx_assert
      ppx_sexp_conv
      ppx_deriving
      ppx_optcomp
      ppx_import
      sexplib
      ppx_yojson_conv
      lsp
      sel
    ]);
  meta = with pkgs.lib; {
    description = "Language server for the vscoq vscode/codium extension";
    homepage = "https://github.com/coq-community/vscoq";
    maintainers = with maintainers; [ cohencyril ];
    license = licenses.mit;
  };
}
