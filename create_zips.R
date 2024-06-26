answers = F

days = 4


# delete log and pdf files
for (d in days) {
  f = c(list.files(path = paste0("day", d), pattern = ".log", full.names = TRUE),
        list.files(path = paste0("day", d), pattern = ".pdf", full.names = TRUE))
  unlink(f)
}




# compile *.Rmd
for (d in days) {
  f = list.files(path = paste0("day", d), pattern = ".Rmd", full.names = TRUE)
  for (fi in f) {
    rmarkdown::render(fi, params = list(answers = answers))
  }
}

library(zip)


# pack pdf files
for (d in days) {
  zfile = paste0("ESTP_RinOS_day", d, ifelse(answers, "_answers", ""),  ".zip")
  unlink(zfile)
  
  f = list.files(path = paste0("day", d), pattern = ".pdf", full.names = TRUE)
  if (!answers) {
    # attach data files
    f2 = list.files(path = paste0("day", d, "/data"), full.names = TRUE)
  } else {
    # attach demo scripts
    f2 = list.files(path = paste0("day", d), pattern = '.*\\.(r|R)$', full.names = TRUE)
  }
  
  # workaround to remove root folder 
  zall = c(f, f2)
  #zall = substr(zall, 6, nchar(zall))
  
  zip(zipfile = zfile, files = zall)
}



f = list.files(path = "day3_afternoon/", full.names = TRUE, recursive = TRUE)
fbase = list.files(path = "day3_afternoon/", recursive = TRUE)

# with answers
fsel = f[!(fbase %in% c("exercises_weighting.pdf"))]
zip(zipfile = "ESTP_RinOS_day3_afternoon_with_answers.zip", files = fsel)

# without answers

fsel = f[!(fbase %in% c("exercises_weighting_with_answers.pdf", "exercises_weighting.Rmd"))]
zip(zipfile = "ESTP_RinOS_day3_afternoon.zip", files = fsel)



