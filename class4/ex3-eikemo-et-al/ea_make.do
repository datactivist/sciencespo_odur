
* Basic panel specification for the multilevel logit models in Eikemo et al.,
* "Welfare State Regimes and Differences in Self-Perceived Health in Europe", 
* Social Science & Medicine, 2008, using ESS Rounds 5-6 data (2010 and 2012).
*
* N = 58,483 adults (level 1), 252 regions (level 2), 18 countries (level 3)
*
* Stata 12 / 2013-11-01 / f.briatte@ed.ac.uk

use ea_data, clear

* prepare variables

run ea_data

* study sample size

misstable pat lsh age female edu class inc4 no_* wr, freq
table wr cntry, col row by(essround)

* nested levels

codebook reg cty wr, c

* naive estimator

logit lsh age female ib3.edu ib1.class ib4.inc4 no_* i.wr [pw = dweight]
logit, or

* random effects

bs, r(5) seed(7432) cl(reg) id(k): ///
	xtlogit lsh age female ib3.edu ib1.class ib4.inc4 no_* i.wr, ///
	re intpoints(7) i(k)
xtlogit, or

* marginal results

la de class 1 U 2 L, replace
margins i.wr#i.inc4#i.class if inc4 > 0 & class > 0, predict(pu0)
marginsplot, by(class wr) recast(connected) plotop(ms(o) mc(gs0) lc(gs4)) ///
	recastci(rcap) ciop(lc(gs0) msiz(0)) ///
	byop(cols(5) ti("Income-related health inequality by income quartiles and social class")) ///
	yline(0, lp(l) lc(gs0)) yline(.1 .2, lp(.) lc(gs8)) xsc(noli) xti("") yti("Pr(Low Self-assessed Health)")
gr export ea_plot.pdf, replace

* kthxbye
