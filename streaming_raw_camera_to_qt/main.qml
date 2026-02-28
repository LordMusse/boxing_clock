import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    visibility: Window.FullScreen
    visible: true
    title: "Camera preview (image provider)"
    property QtObject bridge

    Image {
      id: image
      height: root.height
      source: "image://live//image"
      fillMode: Image.PreserveAspectFit
      asynchronous: false
      cache: false
      property bool counter: false

      function reload() {
        counter = !counter
        source = "image://live//image?id=" + counter
      }
    }

    Text {
      id: mouse_coord
      text: mouse_area.mouseX + "|" + mouse_area.mouseY
    }

    MouseArea {
      id: mouse_area
      anchors.fill: image
      hoverEnabled: true
      onClicked: (mouse)=> {
        var x = mouseX
        var y = mouseY
        var coord = x.toString() + "|" + y.toString();
        console.log(x);
        console.log(y);
        console.log(coord);
      }
    }

    function send_coordinates() {
      console.log(mouse_area.mouseX.toString() + "|" + mouse_area.mouseY.toString())
    }

      function reloaded()
      {
        console.log("reloading")
        image.reload()
      }


    //Image {
    //    id: previewImage
    //    anchors.fill: parent
    //    fillMode: Image.PreserveAspectFit
    //    source: cameraBackend.frameUrl   // backend uppdaterar frameUrl när ny bild finns
    //    cache: false                     // viktigt: disable cache så att QML alltid frågar provider
    //}
}

