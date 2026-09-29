# OpenAI Dot — implementation record

## Accepted scope

Standalone Omarchy plugin dedicated to the user's existing OpenAI Dot. User selected the real Dot web interface in a dedicated app window on 2026-09-29. Perch entry is future work.

ID: `io.github.tcballard.openai-dot`. Kinds: bar-widget and panel. Bar left-click sends the fixed Open payload; right-click toggles help. Panel open with `action: open` launches immediately. All other payloads show help. Repeated opens while the launch process runs are ignored; no duplicate plugin panel is created.

Omarchy owns widget configuration. OpenAI owns conversations, Dot activity and approvals. The user's supported browser owns authentication. No conversation storage, session extraction, general-purpose agent tools, browser automation or API credentials are added.

Dependencies: bash, Omarchy Quattro, omarchy-shell and omarchy-launch-webapp with its supported browser and desktop dependencies. Endpoint: https://chatgpt.com/dots. No privileged operation or installation hook.

The launch runs asynchronously through Quickshell.Io.Process with constant arguments. The panel closes when the command exits successfully. It shows a useful error on a missing helper or failed browser launch. No success indicator claims Dot connectivity. Closing releases keyboard focus; it does not terminate the independently launching browser. Successful launch may open another app window; existing-window focusing depends on the browser.

Help appears in the top-right panel. Dot is a normal compositor-managed app window, not a layer-shell browser. The plugin does not override multi-monitor placement rules. Hidden panels request no keyboard focus. Escape and Close dismiss the panel; there is no fullscreen backdrop or exclusive keyboard grab.

## Evidence and limitations

Official setup: https://help.openai.com/en/articles/20001530-getting-started-with-your-dot
Official introduction: https://openai.com/index/introducing-dots/
Omarchy launcher source: https://github.com/omacom/omarchy/blob/quattro/bin/omarchy-launch-webapp

No documented direct Dot conversation API was found in the official sources searched on 2026-09-29. This is a research limitation, not proof that such an API cannot exist. The implementation uses the published web entry point.

Portable tests exercise the constant command extracted from Panel.qml. Omarchy, Qt/Quickshell imports and a live display are unavailable in the build workspace; host behavior remains unverified.

## Live verification

- Record `omarchy-version`, shell revision, browser and plugin commit.
- Run `omarchy plugin validate` against a fresh checkout and enable it.
- Add the widget; check horizontal/vertical bars and theme changes.
- Left-click and invoke the Open command: real Dot page appears in an app window.
- Verify sign-in, eligible account access, message and reply through the actual web UI.
- Right-click opens help; Tab/Enter, Escape and Close work; hidden panel takes no focus.
- Repeated click during launch creates no concurrent launcher process within the panel.
- Temporarily test missing helper and failed launch using a controlled fixture; restore environment.
- Check multi-monitor placement, shell reload, disable and remove. Browser session remains intact.

## Deferred

Perch entry; verified existing-window focusing; direct Dot conversation/activity/approval integration if OpenAI provides a supported interface. No release until live checks complete.
