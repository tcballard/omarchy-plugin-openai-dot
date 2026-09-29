import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons
import qs.Ui

Item {
  id: root
  property string omarchyPath: ""
  property var shell: null
  property var manifest: null
  property bool opened: false
  property string launchError: ""

  function open(payloadJson) {
    var payload = ({})
    var encoded = String(payloadJson || "{}")
    if (encoded.length <= 16384) {
      try { payload = JSON.parse(encoded) || ({}) }
      catch (error) { payload = ({}) }
    }
    root.opened = true
    if (payload.action === "open") root.launch()
  }

  function close() { root.opened = false }

  function launch() {
    if (launcher.running) return
    root.launchError = ""
    launcher.running = true
  }

  // Constant argv: no payload, credentials or shell-configured command is evaluated.
  Process {
    id: launcher
    command: ["bash", "-c", "if ! command -v omarchy-launch-webapp >/dev/null 2>&1; then exit 127; fi; exec omarchy-launch-webapp https://chatgpt.com/dots"]
    onExited: function(exitCode, exitStatus) {
      if (exitCode === 0 && exitStatus === 0) {
        root.close()
      } else {
        root.launchError = exitCode === 127
          ? "Omarchy’s web-app launcher is missing. Update Omarchy before trying again."
          : "The browser could not be launched. Check your default browser, then try again."
      }
    }
  }

  PanelWindow {
    visible: root.opened
    anchors { top: true; right: true }
    margins { top: Style.gapsOut; right: Style.gapsOut }
    implicitWidth: Style.space(400)
    implicitHeight: content.implicitHeight + Style.spacing.panelPadding * 2
    color: "transparent"
    WlrLayershell.namespace: "io-github-tcballard-openai-dot"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: root.opened ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    exclusionMode: ExclusionMode.Ignore

    BorderSurface {
      anchors.fill: parent
      color: Color.popups.background
      radius: Style.cornerRadius
      borderSpec: Border.surfaceSpec("popups", "border", Color.popups.border, 1)
      padding: Style.spacing.panelPadding

      ColumnLayout {
        id: content
        width: parent.width
        spacing: Style.spacing.md
        focus: root.opened
        Keys.onEscapePressed: root.close()

        Text {
          text: "Your Dot"
          textFormat: Text.PlainText
          color: Color.popups.text
          font.family: Style.font.family
          font.pixelSize: Style.font.title
        }
        Text {
          Layout.fillWidth: true
          wrapMode: Text.WordWrap
          text: "Talk to your OpenAI Dot in its own app window. Sign in through the browser if needed."
          textFormat: Text.PlainText
          color: Color.popups.text
          font.family: Style.font.family
          font.pixelSize: Style.font.body
        }
        Text {
          visible: root.launchError !== ""
          Layout.fillWidth: true
          wrapMode: Text.WordWrap
          text: root.launchError
          textFormat: Text.PlainText
          color: Color.popups.text
          font.pixelSize: Style.font.body
        }
        RowLayout {
          spacing: Style.spacing.md
          Button {
            text: launcher.running ? "Opening…" : "Open Dot"
            enabled: !launcher.running
            onClicked: root.launch()
          }
          Button { text: "Close"; onClicked: root.close() }
        }
      }
    }
  }
}
