#ifndef FLUTTER_PLUGIN_FLEXICOMPONENTS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLEXICOMPONENTS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flexicomponents {

class FlexicomponentsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlexicomponentsPlugin();

  virtual ~FlexicomponentsPlugin();

  // Disallow copy and assign.
  FlexicomponentsPlugin(const FlexicomponentsPlugin&) = delete;
  FlexicomponentsPlugin& operator=(const FlexicomponentsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flexicomponents

#endif  // FLUTTER_PLUGIN_FLEXICOMPONENTS_PLUGIN_H_
