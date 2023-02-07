library(seminr) #to generate SEM PLS
library(readxl) #to import the data from excel format

## calling the dataset

namafile <- read_excel("C:/Users/almo/Dropbox/portofolio/SEM PLS/data dasar.xlsx",
                       sheet = "dasar")


## arrange the item question from each variables

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

## Create the PLS Models

namafile_sm <- relationships(paths(from="X1",
                                   to=c("X2","X3","Y")),
                             paths(from="X2",
                                   to="Y"),
                             paths(from="X3",
                                   to="Y"))


## show the basic models

plot(namafile_sm)


## SEM PLS analysis

namafile_PLS <- estimate_pls(data = namafile,
                             measurement_model = namafile_mm,
                             structural_model = namafile_sm)
model_summary <- summary(namafile_PLS)
model_summary


## show the finale models of SEM PLS

plot(namafile_PLS)


## Convergent Validity test

model_summary$loadings


## composite reliability test

model_summary$reliability


## Discriminant Validity test

model_summary$validity$cross_loadings


## HTMT Value test

model_summary$validity$htmt


## Collinierity test

model_summary$vif_antecedents


## R Square test

model_summary$path


## F square test

model_summary$fSquare


## Boostrapping Model

boot_seminr_model <- bootstrap_model(seminr_model = namafile_PLS,
                                     nboot = 1000,cores = 2,seed = NULL)
hasil_akhir <- summary(boot_seminr_model)
hasil_akhir

## plotting model after boostrapping

plot(boot_seminr_model)


## the result of direct effect in each variables

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


## result Mediated Path

specific_effect_significance(boot_seminr_model=boot_seminr_model,
                             from="X1",through="X2",
                             to="Y",alpha=0.05)
specific_effect_significance(boot_seminr_model=boot_seminr_model,
                             from="X1",through="X3",
                             to="Y",alpha=0.05)


