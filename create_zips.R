answers = F


# delete log and pdf files
for (d in 1:5) {
  f = c(list.files(path = paste0("day", d), pattern = ".log", full.names = TRUE),
        list.files(path = paste0("day", d), pattern = ".pdf", full.names = TRUE))
  unlink(f)
}




# compile *.Rmd
for (d in 1:5) {
  f = list.files(path = paste0("day", d), pattern = ".Rmd", full.names = TRUE)
  for (fi in f) {
    rmarkdown::render(fi, params = list(answers = answers))
  }
}

library(zip)


# pack pdf files
for (d in 1:5) {
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
  
  zip(zipfile = paste0("ESTP_RinOS_day", d, ifelse(answers, "_answers", ""),  ".zip"), files = zall)
}
