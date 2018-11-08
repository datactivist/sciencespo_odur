A session on __how to present data__, illustrated with __(spatial) visualizations__ of __(open) urban data__.

See the [course syllabus][doc-syllabus], the [introductory email][doc-email] and [slides 50–_sq._][doc-slides] of the session for context.

The repository contains two __practical demos__, both of which use [R][r].

To install the dependencies:

```r
install.packages(c('ggplot2', 'rleafmap'))
```

## 1. Cholera deaths in London, 1854

A replication of John Snow's map of [cholera in London, 1854](https://en.wikipedia.org/wiki/1854_Broad_Street_cholera_outbreak), largely inspired by [Arthur Charpentier's blog posts](https://freakonometrics.hypotheses.org/tag/cholera).

The code requires the [ggplot2][r-ggplot2] package.

The data used in the demo are included in the repository and come from Michael Friendly _et al._'s [HistData][r-histdata] package.

## 2. Bicycle sharing in Lyon, France

A replication of François Keck's demo examples for his [rleafmap][r-rleafmap] package, which provides a simple backend to the [Leaflet][js-leaflet] JavaScript library.

Both the code and data for this example come from the [rleafmap][r-rleafmap] package and website.

* * *

Enjoy!

[doc-email]: class4-email.md
[doc-syllabus]: https://frama.link/odur-2018
[doc-slides]: https://frama.link/odur-2018-s4

[js-leaflet]: https://leafletjs.com/

[r]: https://www.r-project.org/

[r-ggplot2]: http://ggplot2.tidyverse.org/reference/
[r-histdata]: https://cran.r-project.org/package=HistData
[r-rleafmap]: http://www.francoiskeck.fr/rleafmap/
