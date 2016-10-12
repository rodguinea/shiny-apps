tech_theme <- function(gplot) {
  require(ggplot2)

  return(gplot +
           theme_minimal() +
           theme(axis.text.x = element_text(angle=45)) )
}

usr_filter_group <- function(data, groups, res_in, gender_in, year_in, greak_in, small = 10) {
  require(dplyr)

  plot_data <- data %>%
    filter(res_pretty %in% res_in) %>%
    filter(gender %in% gender_in) %>%
    filter(class_year %in% year_in) %>%
    filter(greek_pretty %in% greak_in) %>%
    group_by_(.dots = lapply(groups, as.symbol)) %>%
      summarize(count = n_distinct(response_token)) %>%
      mutate(total = sum(count),
             frac = round(100*count/total)) %>%
      ungroup() %>%
    filter(total >= small)

  return(plot_data)
}