
* subjective poor health

gen lsh = (health  > 3) if !mi(health)  // reported low self-assessed health
gen lsi = (hlthhmp < 3) if !mi(hlthhmp) // reported long-standing illness

* socio-demographics

gen female = (gndr == 2) if !mi(gndr)
ren agea age

recode edulvlb (0/129 = 1) (212/229 = 2) (311/323 = 3) (412/423 = 4) (510/800 = 5) (else = 55), gen(edub)
replace edulvla = edub if mi(edulvla)
recode edulvla (1/2 = 1 "Primary") (3 = 2 "Secondary") (4/5 = 3 "Tertiary") (55 = .), gen(edu)

gen no_socnet = (sclmeet < 4) if !mi(sclmeet) // lack of social network
gen no_socsup = (inmdisc > 1) if !mi(inmdisc) // lack of social support
replace no_socsup = (inprdsc < 1) if essround == 6

* income quantiles (including missing)

la de inc4 0 "Missing" 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4", replace // quartiles
recode hinctnt  (1/4 = 1) (5/6 = 2) (7/8 = 3) (9/12 = 4) (else = 0), gen(inc4a)
recode hinctnta (1/3 = 1) (4/5 = 2) (6/7 = 3) (8/10 = 4) (else = 0), gen(inc4b)
tab inc4a inc4b // overlaps
gen inc4:inc4 = inc4a + inc4b

la de inc3 0 "Missing" 1 "Q1" 2 "Q2" 3 "Q3", replace // tertiles
recode hinctnt  (1/5 = 1) (6/8 = 2) (9/12 = 3) (else = 0), gen(inc3a)
recode hinctnta (1/4 = 1) (5/8 = 2) (9/12 = 3) (else = 0), gen(inc3b)
tab inc3a inc3b // overlaps
gen inc3:inc3 = inc3a + inc3b

* group countries

encode cntry, gen(cty)

* group regions

encode region, gen(reg)

* welfare regimes (expanded Ferrera 1996 classification)

gen wr:wr = .
replace wr = 1 if inlist(cntry, "DK", "FI", "NO", "SE")
replace wr = 2 if inlist(cntry, "AT", "BE", "CH", "DE", "FR", "LU", "NL")
replace wr = 3 if inlist(cntry, "GB", "IE")
replace wr = 4 if inlist(cntry, "ES", "GR", "IT", "PT")
replace wr = 5 if inlist(cntry, "CZ", "HU", "PL", "SI")
la de wr 1 "Scandinavian" 2 "Bismarckian" 3 "Anglo-Saxon" 4 "South" 5 "East"
la var wr "Welfare regime"

* study sample

drop if age < 24 | mi(wr)

* The following block of code creates the European Socioeconomic Classification
* syntax for social classes by Harrison and Rose [1]. The code is adapted from
* Leiulfsrud et al.'s SPSS code from the "Social Class in Europe II" report [2].
* [1]: https://www.iser.essex.ac.uk/archives/esec/user-guide
* [2]: http://www.svt.ntnu.no/iss/ClassSyntaxes.html

replace iscoco = isco08 if essround == 6
table cntry, c(n iscoco n emplno n jbspv n emplrel) // required variables

* Simplify ISCO88 to three-digit codes.
recode iscoco ///
	(0/0100=010) (0111=011) (1000=100) (1100=110) (1110=111) (1140/1143=114) ///
	(1200=120) (1210=121) (1220/1229=122) (1230/1239=123) (1300=130) ///
	(1310/1319=131) (2000=200) (2100=210) (2110/2119=211) (2120/2122=212) ///
	(2130/2139=213) (2140/2149=214) (2200=220) (2210/2213=221) (2220/2229=222) ///
	(2230=223) (2300=230) (2310=231) (2320=232) (2330/2332=233) (2340=234) ///
	(2350/2359=235) (2400=240) (2410/2419=241) (2420/2429=242) (2430/2439=243) ///
	(2440/2449=244) (2450/2459=245) (2460=246) (2470=247) (3000=300) (3100=310) ///
	(3110/3119=311) (3120/3129=312) (3130/3139=313) (3140/3145=314) ///
	(3150/3152=315) (3200=320) (3210/3213=321) (3220/3229=322) (3230/3232=323) ///
	(3300=330) (3310=331) (3320=332) (3330=333) (3340=334) (3400=340) ///
	(3410/3419=341) (3420/3429=342) (3430/3434=343) (3440/3449=344) (3450=345) ///
	(3460=346) (3470/3475=347) (3480=348) (4000=400) (4100=410) (4110/4115=411) ///
	(4120/4122=412) (4130/4133=413) (4140/4144=414) (4190=419) (4200=420) ///
	(4210/4215=421) (4220/4223=422) (5000=500) (5100=510) (5110/5113=511) ///
	(5120/5123=512) (5130/5139=513) (5140/5149=514) (5160/5169=516) (5200=520) ///
	(5210=521) (5220=522) (6000=600) (6100=610) (6110/6112=611) (6120/6129=612) ///
	(6130=613) (6140/6142=614) (6150/6154=615) (7000=700) (7100=710) (7110/7113=711) ///
	(7120/7129=712) (7130/7139=713) (7140/7143=714) (7200=720) (7210/7216=721) ///
	(7220/7224=722) (7230/7233=723) (7240/7245=724) (7300=730) (7310/7313=731) ///
	(7320/7324=732) (7330/7332=733) (7340/7346=734) (7400=740) (7410/7416=741) ///
	(7420/7424=742) (7430/7437=743) (7440/7442=744) (8000=800) (8100=810) ///
	(8110/8113=811) (8120/8124=812) (8130/8139=813) (8140/8143=814) (8150/8159=815) ///
	(8160/8163=816) (8170=817) (8200=820) (8210/8212=821) (8220/8229=822) ///
	(8230/8232=823) (8240=824) (8250/8253=825) (8260/8269=826) (8270/8279=827) ///
	(8280/8287=828) (8290=829) (8300=830) (8310/8312=831) (8320/8324=832) ///
	(8330/8334=833) (8340=834) (9000=900) (9100=910) (9110/9113=911) (9120=912) ///
	(9130/9133=913) (9140/9142=914) (9150/9153=915) (9160/9162=916) (9200=920) ///
	(9210/9213=921) (9300=930) (9310/9313=931) (9320=932) (9330=933) (else=.), gen(isco3)
la var isco3 "ISCO88 (3 digits)"

* Derive employment status categories.
recode emplno (0=0) (1/9=1) (10/10000=2) (else=.), gen(empnum)

* Combine basic employment situation with supervision.
gen empstat:empstat=.
replace empstat=1 if (emplrel==2 & empnum==2)
replace empstat=2 if (emplrel==2 & empnum==1)
replace empstat=3 if (emplrel==2 & empnum==0) | (emplrel==2 & empnum==9)
replace empstat=4 if (emplrel==1 & jbspv==1) | (emplrel==3 & jbspv==1)
replace empstat=5 if (emplrel==1 & jbspv>=2) | (emplrel==3 & jbspv>=2)
la var empstat "ESeC employment status variable"
la def empstat ///
	1 "Self-employed 10+ employees" 2 "Self-employed <10 employees" ///
	3 "Self-employed no employees" 4 "Supervisors" 5 "Employees"

* International comparative version of ESeC based on ISCO minor groups.
gen euroesec:euroesec = isco3

* Self-employed 10+ employees.
recode euroesec (344 345=2) (011 516=3) (621=5) (missing=.) (nonmissing=1) if empstat==1

* Small employers <10.
recode euroesec (010 110 111 114 200 210 211 212 213 214 220 221 222 231 235 240 241 242 244=1) ///
	(223 230 232 233 234 243 244 245 246 247 310 311 312 314 320 321 322 323 334 342 344 345 348=2) ///
	(011 516=3) (600 610 611 612 613 614 615 621 920 921=5) (missing=.) (nonmissing=4) if empstat==2

* Self-employed with no employees.
recode euroesec (010 110 111 114 200 210 211 212 213 214 220 221 222 231 235 240 241 242 244=1) ///
	(223 230 232 233 234 243 244 245 246 247 310 311 312 314 320 321 322 323 334 342 344 345 348=2) ///
	(011 516=3) (600 610 611 612 613 614 615 621 920 921=5) (missing=.) (nonmissing=4) if empstat==3

* Supervisors.
recode euroesec (010 100 110 111 114 120 121 123 200 210 211 212 213 214 220 221 222 231 235 240 241 242=1) ///
	(011 122 130 131 223 230 232 233 234 243 244 245 246 247 300 310 311 312 313 314 315 320 321 322 323 330 331 332 333 334 340 341 342 343 344 345 346 347 348 400 410 411 412 419 420 521=2) ///
	(621=5) (missing=.) (nonmissing=6) if empstat==4

* Employees.
recode euroesec (010 110 111 114 120 121 123 200 210 211 212 213 214 220 221 222 231 235 240 241 242=1) ///
	(122 130 131 223 230 232 233 234 243 244 245 246 247 310 311 312 314 320 321 322 323 334 342 344 345 348 521=2) ///
	(011 300 330 331 332 333 340 341 343 346 347 400 410 411 412 419 420=3) (621=5) (313 315 730 731=6) ///
	(413 421 422 500 510 511 513 514 516 520 522 911=7) ///
	(600 610 611 612 613 614 615 700 710 711 712 713 714 720 721 722 723 724 732 733 734 740 741 742 743 744 825 831 834=8) ///
	(414 512 800 810 811 812 813 814 815 816 817 820 821 822 823 824 826 827 828 829 830 832 833 900 910 912 913 914 915 916 920 921 930 931 932 933=9) (missing=.) if empstat==5

* Missing employment statuses, allocated by modal ESS employment status.
recode euroesec (010 110 111 114 120 121 123 200 210 211 212 213 214 220 221 222 231 235 240 241 242=1) ///
	(122 223 230 232 233 234 243 244 245 246 247 310 311 312 314 320 321 322 323 334 342 344 345 348 521=2) ///
	(011 300 330 331 332 333 340 341 343 346 347 400 410 411 412 419 420=3) (130 131 911=4) ///
	(600 610 611 612 621=5) (313 315 730 731=6) (413 421 422 500 510 511 513 514 516 520 522=7) ///
	(614 615 700 710 711 712 713 714 720 721 722 723 724 732 733 734 740 741 742 743 744 825 831 834=8) ///
	(414 512 800 810 811 811 812 813 814 815 816 817 820 821 822 823 824 826 827 828 829 830 832 833 900 910 912 913 914 915 916 920 921 930 931 932 933=9) (missing=.) if mi(empstat)

la var euroesec "European ESeC"
la def euroesec ///
	1 "Large employers, higher mgrs/professionals" ///
	2 "Lower mgrs/professionals, higher supervisory/technicians" ///
	3 "Intermediate occupations" ///
	4 "Small employers and self-employed (non-agriculture)" ///
	5 "Small employers and self-employed (agriculture)" ///
	6 "Lower supervisors and technicians" ///
	7 "Lower sales and service" ///
	8 "Lower technical" ///
	9 "Routine"

replace euroesec=. if euroesec > 9 // missing: armed forces, crop and animal producers

table cntry essround, c(n euroesec) by(wr)

* social class (including missing)

recode euroesec (1/4 = 1 "Upper") (5/9 = 2 "Lower") (else = 0 "Missing"), gen(class)

* now get jiggy with it
