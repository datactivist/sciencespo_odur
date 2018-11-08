# ==============================================================================
#
# Plot the Vélo'V bicycle sharing stations in Lyon, France.
#
# Sources:
#
# - rleafmap package (data and example code)
#   https://cran.r-project.org/package=rleafmap
#
# - François Keck (package author)
#   http://www.francoiskeck.fr/rleafmap/
#
# ==============================================================================

# load required package

library(rleafmap) # 0.2

# create a tile layer object
stamen.bm <- basemap("stamen.toner")

# load Vélo'V spatial dataset
data(velov)

# create spatial data layer
velov.sta <- spLayer(velov, stroke = FALSE, popup = velov$stations.name)

# show map (requires JavaScript + Web connexion)
writeMap(
  stamen.bm, velov.sta, width = 650, height = 500,
  setView = c(45.76, 4.85), setZoom = 12
)

# have a nice day
