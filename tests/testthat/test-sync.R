test_that("errors if no envvar available", {
  withr::with_envvar(c("DARKLY_LIGHT_THEME" = "", "DARKLY_DARK_THEME" = ""), {
    expect_warning(get_light_theme(), regexp = "DARKLY_LIGHT_THEME")
    expect_warning(get_dark_theme(), regexp = "DARKLY_DARK_THEME")
  })
})
