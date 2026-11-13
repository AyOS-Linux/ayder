// Ayder — слайдшоу Calamares (slideshowAPI: 2)
// Одна страница: тёмный слайд с логотипом + минимальный fade-in
// при активации (activatedInCalamares выставляет Calamares на exec-фазе).
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
            Behavior on opacity {
                NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
            }
        }
    }
}
