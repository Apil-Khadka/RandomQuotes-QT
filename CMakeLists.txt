cmake_minimum_required(VERSION 3.16)

project(
  RandomQuotes-QT
  VERSION 0.1
  LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Sql Widgets Gui)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appQuoteMotive main.cpp quotegenerate.h quotegenerate.cpp
                  user.h user.cpp)

qt_add_resources(
  appQuoteMotive
  "resources"
  PREFIX
  "/"
  FILES
  database/quotes.db
  FILES
  images/avatar1.jpg
  FILES
  images/avatar2.jpg
  FILES
  images/avatar3.jpg)

qt_add_qml_module(
  appQuoteMotive
  URI
  QuoteMotive
  VERSION
  1.0
  QML_FILES
  Qml/Main.qml
  Qml/QuoteView.qml
  Qml/InitScreen.qml)

# Android-specific settings
if(ANDROID)
  set_target_properties(
    appQuoteMotive
    PROPERTIES QT_ANDROID_PACKAGE_SOURCE_DIR
               "${CMAKE_CURRENT_SOURCE_DIR}/android"
               QT_ANDROID_PACKAGE_NAME "io.apil.quotiqr"
               QT_ANDROID_TARGET_SDK_VERSION 30
               QT_ANDROID_VERSION_CODE "10"
               QT_ANDROID_VERSION_NAME "1.0")
endif()

# Link necessary Qt components
target_link_libraries(appQuoteMotive PRIVATE Qt6::Quick Qt6::Widgets Qt6::Sql
                                             Qt6::Gui)

# Install paths for different platforms
include(GNUInstallDirs)
install(
  TARGETS appQuoteMotive
  BUNDLE DESTINATION .
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
