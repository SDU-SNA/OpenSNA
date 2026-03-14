//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <battery_plus/battery_plus_windows_plugin.h>
#include <disks_desktop/disks_desktop_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <permission_kit/permission_kit_plugin_c_api.h>
#include <share_plus/share_plus_windows_plugin_c_api.h>
#include <system_monitor_kit/system_monitor_kit_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BatteryPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BatteryPlusWindowsPlugin"));
  DisksDesktopPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DisksDesktopPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  PermissionKitPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionKitPluginCApi"));
  SharePlusWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SharePlusWindowsPluginCApi"));
  SystemMonitorKitPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemMonitorKitPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
