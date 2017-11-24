# ==============================================================================
#
# Top incomes data by Piketty and Saez, September 2013 update.
#
# --- reference ----------------------------------------------------------------
#
# T. Piketty and E. Saez, "Income Inequality in the United States, 1913-1998"
# Quarterly Journal of Economics, 118(1), 2003, 1-39 [ fig. 1 ]
# http://piketty.pse.ens.fr/fichiers/public/PikettySaez2003.pdf
#
# ==============================================================================


## -- packages -----------------------------------------------------------------

library(ggplot2)
library(reshape2)
library(scales)
library(xlsx) # uncomment if you need to download and convert the data

## -- dataset ------------------------------------------------------------------

file <- "incomes.csv"
if (!file.exists(file)) {
  
  download.file("http://emlab.berkeley.edu/~saez/TabFig2012prel.xls",
                file, mode = "wb")
  
  # read XLSX
  ps <- read.xlsx(file, sheetName = "Table A1",
                  startRow = 4, endRow = 105, colIndex = 1:7)
  
  # drop first row
  ps = ps[ -1, ]
  
  # write CSV
  write.csv(ps, file, row.names = FALSE)
  
}

# read CSV
ps <- read.csv(file, stringsAsFactors = FALSE)

## -- variables ----------------------------------------------------------------

# inspect
str(ps)

# names
names(ps) <- c("Year", paste0("top ", c(10, 5, 1, 0.5, 0.1, 0.01), "%"))

# reshape
ps <- melt(ps, id = "Year", variable = "Fractile")

# subset
ps <- na.omit(ps)

# result
head(ps)
tail(ps)

## -- plot ---------------------------------------------------------------------

ggplot(data = ps, aes(x = Year, y = value / 100, linetype = Fractile)) + 
  geom_line() +
  geom_text(data = subset(ps, Year == 2012),
            aes(x = 2014, label = Fractile, hjust = 0)) +
  scale_x_continuous(lim = c(1911, 2021), breaks = seq(1910, 2010, by = 20)) +
  scale_y_continuous(labels = percent) +
  labs(y = "income share, excluding capital gains (%)\n", x = NULL,
       title = "U.S. Top Income Shares of National Revenue, 1917-2012\n") +
  theme_linedraw(12) +
  theme(legend.position = "none")

# uncomment to save last plot
# ggsave("piketty-saez.png", width = 11, height = 8)

## have a nice day
