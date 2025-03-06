{
  # on the Microsoft Natural Ergonomic Keyboard 4000, the zoom slider scrolls
  services.udev.extraHwdb = ''
    evdev:input:b0003v045Ep00DB*
     KEYBOARD_KEY_c022d=pageup   # zoomin
     KEYBOARD_KEY_c022e=pagedown # zoomout
  '';
}
