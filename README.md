# OpenAI Dot

[![Built for Omarchy: Plugin](https://raw.githubusercontent.com/tcballard/omarchy-badges/75975e5b5bf75e7ede3764bcd2950046f7abfe2c/badges/v1/omarchy-plugin.svg)](https://github.com/tcballard/omarchy-badges)

Your OpenAI Dot, one click away on Omarchy. Open the real Dot interface in a dedicated browser app window, using your browser’s existing ChatGPT login.

Unofficial. Development preview; live XPS verification is still required.

## Install

Requires Omarchy Quattro with shell-plugin support, `bash`, `omarchy-launch-webapp`, and a supported browser. The launcher uses Omarchy’s default supported browser, falling back to Chromium. Sign in to ChatGPT in that browser.

```bash
omarchy plugin add https://github.com/tcballard/omarchy-plugin-openai-dot.git --enable
```

Add **OpenAI Dot** in the shell’s bar configuration. Left-click **Dot** to open your Dot; right-click for help. The help panel supports Tab, Enter and Escape, with a visible Close button.

You need an account with Dots access. At launch, personal Pro accounts in the UK, EEA and Switzerland are excluded; Business Premium supports eligible workspaces. This plugin cannot enable account access. See [OpenAI’s current availability and setup guide](https://help.openai.com/en/articles/20001530-getting-started-with-your-dot).

## Open from a shortcut

```bash
omarchy-shell shell summon io.github.tcballard.openai-dot '{"action":"open"}'
```

Without `action`, summon opens the help panel. Unknown payload fields are ignored. Use the same Open command for a future Perch entry.

## How it works

The QML plugin calls `omarchy-launch-webapp https://chatgpt.com/dots`. Your conversations, login, activity and approvals stay in OpenAI’s web interface. No API key or separate agent is needed. The plugin stores no messages or credentials and makes no direct network requests.

It reports local launch failures. Successful launch means the browser accepted the launch, not that your Dot is connected or your account is eligible. Reopening can create another app window, depending on your browser; existing-window focus is not guaranteed. Dot window placement and dismissal follow your ordinary window-manager controls.

There is no native conversation API integration in this version. The standalone plugin can be used without Perch.

## Update and remove

```bash
omarchy plugin update io.github.tcballard.openai-dot
omarchy plugin remove io.github.tcballard.openai-dot
```

Removing the plugin does not close browser windows, sign you out or delete your Dot. It creates no browser profiles, desktop launchers or background services.

## Development and verification

```bash
./tests/run
omarchy plugin validate .
```

Portable checks validate the manifest and exercise the actual launcher command with a stub browser launcher. They cover missing dependencies, successful argument forwarding and launch failure. They do not establish live QML or browser behavior.

Before release, complete [the XPS smoke checks](docs/DESIGN.md#live-verification). No marketplace approval or live compatibility claim is made yet.

MIT © 2026 Tom Ballard
