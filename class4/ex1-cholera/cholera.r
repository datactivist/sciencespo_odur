# ==============================================================================
#
# Draw John Snow's map of cholera deaths in London streets, 1854.
# Source: http://freakonometrics.hypotheses.org/tag/cholera
#
# ==============================================================================

library(ggplot2)
library(HistData)

# load historical datasets
data(Snow.deaths)
data(Snow.streets)

# ==============================================================================
# INSPECT PLOT ELEMENTS
# ==============================================================================

g <- ggplot(data = Snow.deaths, aes(x = x, y = y)) +
  geom_line(data = Snow.streets, aes(group = street), color = "grey50") +
  coord_equal() +
  labs(x = NULL, y = NULL) +
  theme(panel.background = element_blank(),
        panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())

# basic map layer
g

# add cholera deaths data points
g + geom_point(color = "darkred", alpha = .5)

# add 2-dimensional density curves
g + geom_density2d()

# ==============================================================================
# COMBINE PLOT ELEMENTS
# ==============================================================================

g + geom_density2d(aes(color = ..level..)) +
  stat_density2d(aes(fill = ..level..), alpha = .25, geom = "polygon") +
  geom_point(color = "darkred", alpha = .5) +
  scale_fill_gradient(low = "gold", high = "tomato") +
  scale_color_gradient(low = "gold", high = "tomato") +
  guides(color = FALSE, fill = FALSE) +
  ggtitle("Cholera deaths in London, 1854")

# have a nice day
