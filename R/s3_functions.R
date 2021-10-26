#' Summary for class ad_ana_data
#' 
#' @inheritParams parameters
#' @return The summary of this class
#' @export
#'
summary.ad_ana_data <- function(dat, vars = NULL, ...) {
  x <- dat$ana_dt
  pat <- x %>% distinct(subject_id, .keep_all = TRUE)
  n_pat <- dim(pat)[1]
  n_var <- dim(pat)[2]
  
  cat('Data source:',               toupper(dat$dat_ty), 
      '\nNumber of participants:', n_pat, 
      '\nMerged by:',               'subject_id', 
      '\nWindow settings:',    unlist(dat$window_setting))
  
  if(!is.null(vars)) {
    for (i in vars) {
      info <- adt_query_cate(x, i)
      cat(info[[1]]$adt_col_name, ':', info[[1]]$description, 
          '\nvalues:', info[[1]]$values, '\nstatistics:\n')
      print(info[[2]])
      cat('\n')
    }
  }
}

#' Plot for class ad_ana_data
#'
#' @inheritParams parameters
#'
#' @return
#' @export
#'
#' @examples
plot.ad_ana_data <- function(dat, 
                             distn, # extend ...
                             group, 
                             baseline = TRUE, 
                             ...) {
  x <- dat$ana_dt
  # --------------- only first visit ------------------
  x <- x %>%
    mutate(sex_group = recode(sex, '1'='Male','2'='Female')) %>%
    mutate(age =  startyear - birthyear) %>% # define above [maybe into demo]
    mutate(age_group = case_when(age <  10            ~ 'under 10',
                                 age >= 10 & age < 20 ~ '10-19',
                                 age >= 20 & age < 30 ~ '20-29',
                                 age >= 30 & age < 40 ~ '30-39',
                                 age >= 40 & age < 50 ~ '40-49',
                                 age >= 50 & age < 60 ~ '50-59',
                                 age >= 60 & age < 70 ~ '60-69',
                                 age >= 70 & age < 80 ~ '70-79',
                                 age >= 80 & age < 90 ~ '80-89',
                                 age >= 90            ~ 'above 89')) %>%
    group_by(subject_id) %>%
    mutate(visit = row_number()) %>%
    mutate(year = if_else(as.numeric(format(date_cog, '%Y')) - startyear < 0,
                          0, as.numeric(format(date_cog, '%Y')) - startyear)) %>%
    ungroup()
  pat <- x %>% 
    select(subject_id, distn, group)

  if (baseline) {
    pat <- pat %>% 
      distinct(subject_id, .keep_all = TRUE)
  }
  
  tbl <- a_gen_tbl(pat, group, distn)
  p <- ggplot(pat) + 
    theme_bw() + 
    geom_bar(aes(x = !!as.name(distn), color = !!as.name(group), fill = !!as.name(group)), 
             position = 'stack', alpha = 0.9) + 
    labs(x = distn, y = 'Number of Subjects', title = 'Participant Distribution') + 
    theme(plot.title = element_text(size = 12, face = 'bold', hjust = 0.5))
  
  grid.arrange(tableGrob(tbl), p, 
               ncol = 2, as.table = TRUE, widths = c(1, 1.2))
}