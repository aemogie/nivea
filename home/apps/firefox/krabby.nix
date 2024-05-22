{
  stdenv,
  jq,
  zip,
  curl,
  fetchurl,
  fetchFromGitHub,
  ...
}:
{
  krabby = stdenv.mkDerivation {
    pname = "krabby";
    version = "abandoned";
    nativeBuildInputs = [
      jq
      zip
      curl
    ];
    postUnpack = ''
      # scripts/fetch
      self="$PWD/source"
      mkdir source/share/krabby/packages
      pushd source/share/krabby/packages
      cp    $modal/src/modal.js          modal.js
      cp    $mouseselection              mouse-selection.js
      cp    $prompt/src/prompt.js        prompt.js
      cp    $hint/src/hint.js            hint.js
      cp    $mark/src/mark.js            mark.js
      cp    $selection/src/selection.js  selection.js
      cp    $selection/src/selection.css selection.css
      cp    $mouse/src/mouse.js          mouse.js
      cp    $clipboard/src/clipboard.js  clipboard.js
      cp    $scroll/src/scroll.js        scroll.js
      cp    $player/src/player.js        player.js
      cp    $krabbysvg                   krabby.svg
      cp    $krabbypng                   krabby.png

      cp -r $self/src/krabby             krabby
      popd
    '';
    buildPhase = ''
      pushd share/krabby
      ../../scripts/build-target firefox
      find .
      popd
    '';
    installPhase = ''
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p $dst
      cp share/krabby/target/firefox/package.zip "$dst/krabby@mozilla.org.xpi"
    '';
    src = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "krabby";
      rev = "d2aaf88193a4c92606c31aa39bbd574c83777606";
      sha256 = "sha256-Sh918Sp7eTtzpyuKXb/Btrvo09UXkWdwZLXFu3NTlDY=";
    };
    modal = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "modal.js";
      rev = "406523809eeca46fe27b02b84217e00a32287457";
      sha256 = "sha256-IDjJR66kz724rvUifqOa9FsTSER9sIqJ+A9SuCZELto=";
    };
    mouseselection = fetchurl {
      url = "https://cdn.jsdelivr.net/npm/@simonwep/selection-js/dist/selection.min.js";
      sha256 = "sha256-HD0ZnDGv3CsqZmdYxkgQqar7Z1AyQLQ0iBbxBUdrwcg=";
    };
    prompt = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "prompt.js";
      rev = "455163218ed324e695ca5bdde76abe608a1a4438";
      sha256 = "sha256-o4xwqSQNNeIOXlubx1K/2dYTVhNw8sF+DeGALVYA+G0=";
    };
    hint = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "hint.js";
      rev = "d271f50734b3a94059e3e7d5c636cd952578a033";
      sha256 = "sha256-UPD+aLBs4mVIVGyKHYCGGadi28Ih+k0ellc1c6GSq80=";
    };
    mark = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "mark.js";
      rev = "afd02017d5c88624315081ed89d630e2102799d0";
      sha256 = "sha256-pUHTNIGHdOCXYG1v7cqy7xlmo1l40lYvjf2b/wYMrdA=";
    };
    selection = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "selection.js";
      rev = "a78a386606e6760bea73a217209fd808a551c47f";
      sha256 = "sha256-fGE+XMXkqp7ss9LMYPZYyOAtz5+laxOOBObdHFGVhCE=";
    };
    mouse = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "mouse.js";
      rev = "12ba362d20a23279f3e9c277ded0cf8a3d90b1cb";
      sha256 = "sha256-ywRX3xZUJmzydhnQx/tpQeBwbIwE+LpH5P9Tkc++eJE=";
    };
    clipboard = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "clipboard.js";
      rev = "d4ead4504f69d95066478d690b7b765b6bf45aeb";
      sha256 = "sha256-pOgHqepIVLHuuAOUYfNtXWP6FRTEmtj4bHorhQrFgJQ=";
    };
    scroll = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "scroll.js";
      rev = "fd637b8c8441ea5d9da00e07e4f3a2a2982f97b8";
      sha256 = "sha256-Ms6lChTUcCwZWxmwOI1RgezdfxIIWfTPw29bWle2PIo=";
    };
    player = fetchFromGitHub {
      owner = "alexherbo2";
      repo = "player.js";
      rev = "064a8f7adbca56647b7dad3e075fc57b4e13c513";
      sha256 = "sha256-Dc3vERvP3t+xhfKavYP0hI5+3lfkP7Qv84FQHSYLcxY=";
    };
    krabbysvg = fetchurl {
      url = "https://iconfinder.com/icons/877852/download/svg/512";
      sha256 = "sha256-ivT3eP+vqxVhOOllUCPp6D/mYxmFzpN3cFw2bgDcs9g=";
    };
    krabbypng = fetchurl {
      url = "https://iconfinder.com/icons/877852/download/png/512";
      sha256 = "sha256-n2NdUXaTEHANuppyJRaKUmlQ1A1ztlaHoOACauBy9GE=";
    };
  };
}
