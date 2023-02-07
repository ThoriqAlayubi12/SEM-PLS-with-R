# SEM-PLS WITH R

the R script to run the structural equation model partial least square (SEM PLS) with with the dummy data that available in this branch "data dasar.xlsx". so, here we go!

## Activate the Package

in this case, we will use the package of "seminr" and "readxl". if the package is not install at your computer, firstly, we must instal the package with the following script
```{r}
> install.packages("seminR")
> install.packages("readxl")
```
then we must calling the package with following script
```{r}
library(seminR) #to generate SEM-PLS analysis
library(readxl) #to import the data with format excel
```

## calling the dataset

```{r, echo=T}
namafile <- read_excel("C:/Users/almo/Dropbox/portofolio/SEM PLS/data dasar.xlsx",
                       sheet = "dasar")
```

## arrange the item question from each variables
```{r}
namafile_mm <- constructs(composite("X1",
                                    multi_items("O",
                                                c(1:9))),
                          composite("X2",
                                    multi_items("S",
                                                c(1:10))),
                          composite("Y",
                                    multi_items("WB",
                                                c(1:16))),
                          composite("X3",
                                    multi_items("Y",
                                                c(1:5))))
namafile_mm <-as.reflective(namafile_mm)
```

## Create the PLS Models
```{r}
namafile_sm <- relationships(paths(from="X1",
                                   to=c("X2","X3","Y")),
                             paths(from="X2",
                                   to="Y"),
                             paths(from="X3",
                                   to="Y"))
```

## show the basic models
```{r}
plot(namafile_sm)
```

## SEM PLS analysis
```{r}
namafile_PLS <- estimate_pls(data = namafile,
                             measurement_model = namafile_mm,
                             structural_model = namafile_sm)
model_summary <- summary(namafile_PLS)
model_summary
```

## show the finale models of SEM PLS
```{r}
plot(namafile_PLS)
```

## Convergent Validity test
test will be valid if the factor loading value > 0.5
```{r}
model_summary$loadings
```

## composite reliability test
the composite reliability test indicate based on 2 values:
1. AVE value > 0.5
2. rhoA value > 0.7

```{r}
model_summary$reliability
```

## Discriminant Validity test
the value will show the greatest value in each own variables
```{r}
model_summary$validity$cross_loadings
```

## HTMT Value test
```{r}
model_summary$validity$htmt
```

## Collinierity test
VIF value must be greater than 0.2 and less than 5
```{r}
model_summary$vif_antecedents
```

## R Square test
```{r}
model_summary$path
```

## F square test
```{r}
model_summary$fSquare
```

## Boostrapping Model
```{r}
boot_seminr_model <- bootstrap_model(seminr_model = namafile_PLS,
                                     nboot = 1000,cores = 2,seed = NULL)
hasil_akhir <- summary(boot_seminr_model)
hasil_akhir
```
## plotting model after boostrapping
```{r}
plot(boot_seminr_model)
```

## the result of direct effect in each variables
```{r}
specific_effect_significance(boot_seminr_model=boot_seminr_model,
                             from="X1",to="X2",alpha=0.05)
specific_effect_significance(boot_seminr_model=boot_seminr_model,
                             from="X1",to="X3",alpha=0.05)
specific_effect_significance(boot_seminr_model=boot_seminr_model,
                             from="X1",to="Y",alpha=0.05)
specific_effect_significance(boot_seminr_model=boot_seminr_model,
                             from="X2",to="Y",alpha=0.05)
specific_effect_significance(boot_seminr_model=boot_seminr_model,
                             from="X3",to="Y",alpha=0.05)
```

## result Mediated Path
```{r}
specific_effect_significance(boot_seminr_model=boot_seminr_model,
                             from="X1",through="X2",
                             to="Y",alpha=0.05)
specific_effect_significance(boot_seminr_model=boot_seminr_model,
                             from="X1",through="X3",
                             to="Y",alpha=0.05)
```
