import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.tcballard.openai-dot"
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.vertical ? "●" : "Dot"
    tooltipText: "Open your OpenAI Dot · right-click for help"
    onPressed: function(mouseButton) {
      if (!root.bar) return
      if (mouseButton === Qt.LeftButton)
        root.bar.run("omarchy-shell shell summon io.github.tcballard.openai-dot '{\"action\":\"open\"}'")
      else if (mouseButton === Qt.RightButton)
        root.bar.run("omarchy-shell shell toggle io.github.tcballard.openai-dot '{}'")
    }
  }
}
