# ==============================================================================
#
# Redraw John Snow's map of cholera deaths in London streets, 1854.
#
# Sources:
#
# - HistData package (data)
#   https://cran.r-project.org/package=HistData
#
# - Arthur Charpentier (R code)
#   http://freakonometrics.hypotheses.org/tag/cholera
#
# ==============================================================================

# load required packages

library(ggplot2) # 3.0.0

# load historical datasets (from the HistData package)

Snow.deaths  <- read.csv("Snow.deaths.csv"  , stringsAsFactors = FALSE)
Snow.streets <- read.csv("Snow.streets.csv" , stringsAsFactors = FALSE)

# ==============================================================================
# [1] Draw static map of London streets in 1854
# ==============================================================================

# understand the data structure
ggplot(data = Snow.streets, aes(x = x, y = y)) +
  geom_point(color = "black") +
  geom_line(aes(group = street), color = "steelblue")

# plot street coordinates
g <- ggplot(data = Snow.streets, aes(x = x, y = y)) +
  geom_line(aes(group = street), color = "grey50") +
  coord_equal() # equalize longitude and latitude

# basic map layer
g

# remove unrequired plot (axis) elements
g <- g + 
  labs(x = NULL, y = NULL) + # remove titles
  theme(panel.background = element_blank(),
        panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())

# finalized street map
g

# ==============================================================================
# [2] Add John Snow's records of cholera deaths
# ==============================================================================

# understand the relevant geometry
g + geom_point(
  data = Snow.deaths,
  aes(x, y)
)

# create a layer of geolocalised cholera deaths
p <- geom_point(
  data = Snow.deaths,
  aes(x, y),
  size = 2, color = "darkred", alpha = .5
)

# street map + cholera data layer
g + p

# ==============================================================================
# [3] Emphasize affected areas with density curves
# ==============================================================================

# draw 2-dimensional density curves
g + 
  # cholera deaths
  p +
  geom_density2d(
    data = Snow.deaths,
    aes(x, y)
  )

# fill density curves with custom color gradient
g + 
  # cholera deaths
  p +
  stat_density2d(
    data = Snow.deaths,
    aes(x, y, fill = ..level..), 
    alpha = .25, geom = "polygon"
  ) +
  scale_fill_gradient(low = "gold", high = "tomato")

# ==============================================================================
# [4] Combine all plot elements
# ==============================================================================

g + 
  # density curves (outline)
  geom_density2d(
    data = Snow.deaths,
    aes(x, y, color = ..level..)
  ) +
  # density curves (fill)
  stat_density2d(
    data = Snow.deaths,
    aes(fill = ..level..), 
    alpha = .25, geom = "polygon"
  ) +
  # cholera deaths (loaded last to show on top of density curves)
  p +
  # custom colors (outline and fill)
  scale_color_gradient(low = "gold", high = "tomato") +
  scale_fill_gradient(low = "gold", high = "tomato") +
  # hide legends
  guides(color = FALSE, fill = FALSE)

# add titles and save in PDF format

ggsave(
  "cholera-map.pdf",
  last_plot() +
    ggtitle(
      label = "Cholera deaths in London, 1854",
      subtitle = "Based on John Snow's investigation of the Broad Street outbreak."
    )
)

# have a nice day
