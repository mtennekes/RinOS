# delete log and pdf files
for (d in 1:5) {
  f = c(list.files(path = paste0("day", d), pattern = ".log", full.names = TRUE),
        list.files(path = paste0("day", d), pattern = ".pdf", full.names = TRUE))
  unlink(f)
}

# compile *.Rmd
for (d in 1:5) {
  f = list.files(path = paste0("day", d), pattern = ".Rmd", full.names = TRUE)
  for (fi in f) rmarkdown::render(fi)
}


library(zip)

# pack pdf files
for (d in 1:5) {
  f = list.files(path = paste0("day", d), pattern = ".pdf", full.names = TRUE)
  zip(zipfile = paste0("ESTP_RinOS_day", d, ".zip"), files = f)
}
