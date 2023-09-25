#include "include/flexicomponents/flexicomponents_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flexicomponents_plugin.h"

void FlexicomponentsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flexicomponents::FlexicomponentsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
