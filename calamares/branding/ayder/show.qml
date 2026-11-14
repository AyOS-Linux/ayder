// Ayder — слайдшоу Calamares (slideshowAPI: 2)
// Одна страница: тёмный слайд с логотипом. Плавное появление на exec-фазе:
// fade + лёгкий zoom, 650 мс (activatedInCalamares выставляет Calamares).
import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    function onActivate() { presentation.currentSlide = 0; }
    function onLeave() { }

    Slide {
        Image {
            source: "slide3.png"
            width: parent.width
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent

            opacity: presentation.activatedInCalamares ? 1 : 0
            scale: presentation.activatedInCalamares ? 1 : 0.96

            Behavior on opacity {
                NumberAnimation { duration: 650; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: 650; easing.type: Easing.OutCubic }
            }
        }
    }
}
