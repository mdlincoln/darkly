#' Synchronize RStudio theme with OS appearance
#'
#' @export
#' @name darkly_sync
NULL

#' @describeIn darkly_sync Gets the OS appearance and applies the selected RStudio editor theme
darkly_sync <- function() {
  if (!rstudioapi::isAvailable(version_needed = "1.2.879")) {
    message("rstudioapi is not available. darkly_sync will do nothing")
    return(invisible())
  }
  
  os_appearance <- get_os_appearance()
  
  if (os_appearance == "light") {
    set_light()
  } else if (os_appearance == "dark") {
    set_dark()
  }
}

#' Toggle between dark and light theme
#'
#' This does not check the system at all, but merely swaps between the specified
#' dark and light theme. If the editor theme has been set to a theme other than
#' the ones sepcified by the `DARKLY_LIGHT_THEME` and `DARKLY_DARK_THEME`
#' environment variables, darkly_toggle() will change the appearance to the
#' light theme.
#'
#' @export
darkly_toggle <- function() {
  light_theme <- get_light_theme()
  dark_theme <- get_dark_theme()
  if (is.null(light_theme) || is.null(dark_theme)) 
    return()
  
  if (rstudioapi::isAvailable()) {
    current_theme <- rstudioapi::getThemeInfo()["editor"]
    if (current_theme == light_theme) {
      set_dark()
    } else {
      set_light()
    }
  }
}

#' @describeIn darkly_sync Reads the darkly light theme
#' @export
get_light_theme <- function() {
  light_theme <- Sys.getenv("DARKLY_LIGHT_THEME")
  if (!nzchar(light_theme)) {
    message("DARKLY_LIGHT_THEME is not set in your .Renviron. Run darkly::use_darkly() to install it.")
    return(NULL)
  }
  light_theme
}

#' @describeIn darkly_sync Reads the darkly dark theme
#' @export
get_dark_theme <- function() {
  dark_theme <- Sys.getenv("DARKLY_DARK_THEME")
  if (!nzchar(dark_theme)) {
    message("DARKLY_DARK_THEME is not set in your .Renviron. Run darkly::use_darkly() to install it.")
    return(NULL)
  }
  dark_theme
}

#' @describeIn darkly_sync Set RStudio editor to the darkly light theme
#' @export
set_light <- function() {
  light_theme <- get_light_theme()
  if (!is.null(light_theme)) 
    rstudioapi::applyTheme(light_theme)
}

#' @describeIn darkly_sync Set RStudio editor to the darkly dark theme
#' @export
set_dark <- function() {
  dark_theme <- get_dark_theme()
  if (!is.null(dark_theme)) 
    rstudioapi::applyTheme(dark_theme)
}

#' Collect the operating system appearance
#'
#' Checks the system name and then dispatches the appropriate appearance handler
#'
#' @noRd
get_os_appearance <- function() {
  sys <- Sys.info()["sysname"]
  
  get_appearance <- switch(sys, Darwin = get_mac_appearance, Windows = get_windows_appearance, get_X11_appearance)
  get_appearance()
}

get_mac_appearance <- function() {
  suppressWarnings(mac_theme <- system2("defaults", args = c("read -g AppleInterfaceStyle"), stdout = TRUE, 
    stderr = TRUE))
  if (length(mac_theme) > 0) 
    if (mac_theme[1] == "Dark") 
      return("dark")
  return("light")
}

# TODO read some kind of registry setting with readRegistry
get_windows_appearance <- function() {
  message("Windows is not yet supported by darkly")
}

get_X11_appearance <- function() {
  message("X11 systems are not yet supported by darkly")
}
