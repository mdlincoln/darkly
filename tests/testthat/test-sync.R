test_that("warns if no envvar available", {
  withr::with_envvar(c("DARKLY_LIGHT_THEME" = "", "DARKLY_DARK_THEME" = ""), {
    expect_warning(get_light_theme(), regexp = "DARKLY_LIGHT_THEME")
    expect_warning(get_dark_theme(), regexp = "DARKLY_DARK_THEME")
  })
})

test_that("returns correct envvar", {
  lt = "Texmate (default)"
  dt = "Solarized Dark"
  withr::with_envvar(c("DARKLY_LIGHT_THEME" = lt, "DARKLY_DARK_THEME" = dt), {
    expect_equivalent(get_light_theme(), lt)
    expect_equivalent(get_dark_theme(), dt)
  })
})
