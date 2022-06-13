library(dplyr)
library(dbplyr)

# create a database
con <- DBI::dbConnect(RSQLite::SQLite())

# copy some data to the database
DBI::dbWriteTable(con, "iris", iris)

# retrieve a reference to the table in the database
tbl_iris <- tbl(con, "iris")

# this now a link to the table in the database
tbl_iris

query <- 
  tbl_iris %>% 
  mutate(silly = 1)

print(query)
show_query(query)

query <- 
  tbl_iris %>% 
  group_by(Species) %>% 
  summarize( mean_sepal_length = mean(Sepal.Length, na.rm=TRUE)
           , mean_sepal_width = mean(Sepal.Width, na.rm = TRUE)
           ) %>% 
  mutate(ratio = mean_sepal_length / mean_sepal_width)

print(query)
show_query(query)

# you can also directly use SQL on the database
DBI::dbGetQuery(con, "SELECT * FROM iris")
