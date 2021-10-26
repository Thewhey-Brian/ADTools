library(tidyverse)

adt_get_adni <- function() {
  
}

#table_dict <- read.csv("https://raw.githubusercontent.com/Thewhey-Brian/ADNI_Tools/master/tables_dictionary.csv", 
#                        header = T)[, -c(1, 8)]
var_dict <- read.csv("https://raw.githubusercontent.com/Thewhey-Brian/ADNI_Tools/master/variables_dictionary.csv", 
                     header = T)[, -1]
list_data <- list.files(path = "/Users/xinyuguo/OneDrive - Johns Hopkins/AD Biomarker/AD_Tools/ADTool/ADNI_data/All_data", 
                        pattern = ".csv", 
                        full.names = T)
# "DIAG"    "COG"     "APOE"    "CSF"     "IMAGING" "DEMO"   

# --------------------------------
# Merge CSF
# --------------------------------
input_files <- var_dict %>% 
  filter(Type == "CSF") %>% 
  distinct(File)
file_names <- input_files$File
# load data
file_dirs <- list_data[unlist(lapply(file_names, 
                                     grep, 
                                     x = list_data))]
list_csf <- c()
names_csf <- c()
dat_csf <- data.frame()
for (tbl in file_dirs) {
  tem_data <- read.csv(tbl, header = T)
  name_data <- gsub(".csv", "", basename(tbl))
  tem_ver_dict <- var_dict %>% 
    filter(File == name_data & !is.na(Inter_name))
  tem_data <- tem_data %>% 
    select(tem_ver_dict$Vatiables)
  names(tem_data) <- tem_ver_dict$Inter_name
  assign(name_data, tem_data)
  list_csf <- c(list_csf, name_data)
  names_csf <- union(names_csf, names(tem_data))
}
for (tbl in list_csf) {
  extra_var <- setdiff(names_csf, 
                       names(get(tbl)))
  if(length(extra_var) != 0) {
    for (newcol in extra_var) {
      tem_data <- get(tbl) %>% 
        mutate(!!newcol := NA)
      assign(tbl, tem_data)
    } 
  }
  dat_csf <- rbind(dat_csf, get(tbl))
}







