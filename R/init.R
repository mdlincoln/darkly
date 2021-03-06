#' Install darkly helper function
#'
#' This installs a helper function into your RProfile that will check the OS
#' appearance and apply your chosen light or dark theme appropriately. Preferred
#' themes are stored in the global .Renviron file.
#'
#' @param light_theme Character. Name of your preferred light theme.
#' @param dark_theme Character. Name of your preferred dark theme.
#'
#' @return NULL
#' @export
use_darkly <- function(light_theme = "Textmate (default)", dark_theme = "Solarized Dark") {
  setup_darkly_environ(light_theme, dark_theme)
  
  add_environ <- usethis::ui_yeah("Sync theme on RStudio startup? (Currently available for OS X only)")
  if (add_environ) {
    setup_darkly_profile()
  } else {
    message("Quitting darkly initialization. To start again, re-run darkly::use_darkly()")
    invisible(FALSE)
  }
}

#' Guides user through envvar setup
#' @noRd
setup_darkly_environ <- function(light_theme, dark_theme) {
  envirs <- c(paste0("DARKLY_LIGHT_THEME=", light_theme), paste0("DARKLY_DARK_THEME=", dark_theme))
  usethis::ui_todo("Paste the following lines into your .Renviron")
  usethis::ui_code_block(envirs)
  usethis::edit_r_environ()
}

#' Guides user through Rprofile setup
#' @noRd
setup_darkly_profile <- function() {
  usethis::ui_todo("Paste the following line into your Rprofile")
  check_command <- c("# On load, synchronize the RStudio editor theme to the OS appearance using the darkly package", "setHook(\"rstudio.sessionInit\", function(newSession) if (interactive() & require(\"darkly\", quietly = TRUE)) darkly::darkly_sync(), action = \"append\")")
  usethis::ui_code_block(check_command)
  usethis::edit_r_profile()
}
