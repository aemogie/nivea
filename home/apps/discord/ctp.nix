{
  pkgs,
  config,
  osConfig,
  ...
}:
let
  inherit (osConfig.paint.active.ctpCompat) flavor accent;
  inherit (osConfig.paint.active.palette) base mantle crust;
  ctp = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    # NOTE: on the gh-pages branch
    rev = "9b7e9008c727cd056c20c82eae11471d22efe1e3";
    sha256 = "sha256-nZyNY4wOpMs2hPfn6ieUSfOqdPUf45VQm8+9mdUIGRg=";
  };
in
#css
''
  ${builtins.readFile "${ctp}/dist/catppuccin-${flavor}-${accent}.theme.css"}

  :root {
    --font-sans: ${config.fonts.sans}, sans-serif;
    --font-mono: ${config.fonts.monospace}, monospace;

    --font-primary: var(--font-sans);
    --font-headline: var(--font-sans);
    --font-display: var(--font-sans);
    --font-code: var(--font-mono);
  }

  /* remove chatbox gift, gif, sticker and emoji icons. */
  :has(>.expression-picker-chat-input-button) {
      display: none;
  }

  code {
    font-stretch: expanded;
  }
  [class^="messageContent"], [class*=" messageContent"] {
    font-size: 95% !important;
    letter-spacing: -0.25px;
  }

  /* most of it happens here */
  html.theme-light, html.theme-dark {
    /* 0xB2 = 0.7 * 0xFF */
    background: #${base}B2 !important;
    --background-primary: #${base}00 !important;
    --background-secondary: #${mantle}00 !important;
    --background-secondary-alt: #${mantle}00 !important;
    --background-tertiary: transparent !important;
    --channeltextarea-background: #${crust}00 !important;
    /* forum page uses this? */
    --home-background: transparent !important;
  }

  html.theme-light code.hljs, html.theme-dark code.hljs {
     background: #${base} !important;
  }

  html.theme-light span[class*="username__"] {
      filter: brightness(.5);
  }

  div[class^="chat"] section[class*="forumOrHome_"],
  div[class^="chat"] > div[class^="content"] > div[class^="container"] div[class*="mainCard_"] {
    background: transparent !important;
  }
''
