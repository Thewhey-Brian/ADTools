# ADTools


Sharp increases in Alzheimer disease (AD) cases, deaths, and
    costs are stressing the health care system and caregivers. Several major AD data
    sources exist which allows researchers to conduct their research. For example,
    the BIOCARD study is a longitudinal, observational study initiated in 1995, and
    designed to identify biomarkers associated with progression from cognitively
    normal to mild cognitive impairment or dementia; the ADNI study is a multicenter
    observation study launched in 2004, to collect clinical, imaging, genetic and
    biospecimen biomarkers from cohorts of different clinical states at baseline;
    the NACC UDS data is a collection of data reflecting the total enrollment since
    2005 across 34 AD Centers and includes subjects with a range of cognitive
    status. In this package, we establish AD data standards and data dictionaries in
    this package that define the formats and organization structures of the AD data
    across multiple data sources. R Functions are provided for data analysts to
    integrate data from multiple data sources and create their analysis datasets.


# Installation

### Requirement
- Installation of Java. Please visit http://www.java.com for information on installing Java.
- All BIOCARD files have to be the same format. For example, .csv or .xls (the first row should be variable names/headers).

Use the following codes to install the ADTools package
```R
library(devtools)
install_github("Thewhey-Brian/ADTools")
```

# Usage

### Preparations for loading data
To calssify each variable more accurately, the data type need to be clarified before loading into R. ADTools uses keywords matching to achieve this goal. to check the default keywords, please see the "src_key_words" column in the result of
```R
adt_get_dict("src_files")
```
There are two ways to match the files properly:
1. Change the files name corresponding to the default keywords.
2. Change the default keywords: 
Save the outputs from
```R
adt_get_dict("src_files")
```
and change the keywords. Then pass it to the merging function:
```R
dt_biocard = adt_get_biocard(path, src_tables = "dict_src_tables.xlsx")
```

### Merging
#### Main inputs: 
- ***path:*** data direction
- ***reference_time:*** reference time for merging data for each patient
#### Main outputs: 
- An S3 object including the analysis dataset

```R
# ref: the reference time for merging
# win: the window setting for each categories of variable
dt_biocard = adt_get_biocard(path, reference_time = ref, window_setting = win, src_tables = "dict_src_tables.xlsx")
```
Please use the help function to get more detailed information about the function setting
```R
?adt_get_biocard
```

### Variable interpretation
To check the meaning the each variable in the returned analysis dataset, please use function
```R
analysis_data = dt_biocard$ana_dt
adt_tk_query(analysis_data, "variable name")
```

### Exploritory analysis
With the outputed S3 object, use the following functions to check the summary and plot statistics for intersted variables
```R
summary(dt_biocard)
plot(dt_biocard, distn = "gender", group = age, baseline = TRUE)
```
Please use the help function to get more detailed information about the function setting.

