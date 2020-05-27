* Encoding: UTF-8.

DATASET ACTIVATE DataSet1.
DESCRIPTIVES VARIABLES=pain1 pain2 pain3 pain4
  /STATISTICS=MEAN STDDEV MIN MAX.

VARSTOCASES
  /MAKE Pain FROM pain1 pain2 pain3 pain4
  /INDEX=Time(4) 
  /KEEP=ID age Female STAI_trait pain_cat mindfulness cortisol_serum 
  /NULL=KEEP.

MIXED Pain WITH age Female STAI_trait pain_cat mindfulness cortisol_serum Time
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age Female STAI_trait pain_cat mindfulness cortisol_serum Time | SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(ID) COVTYPE(VC)
  /SAVE=PRED.

MIXED Pain WITH age Female STAI_trait pain_cat mindfulness cortisol_serum Time
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age Female STAI_trait pain_cat mindfulness cortisol_serum Time | SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT Time | SUBJECT(ID) COVTYPE(UN)
  /SAVE=PRED.

VARSTOCASES
  /MAKE Pain FROM Pain PRED_Inter PRED_Slope
  /INDEX=PainVersion(Pain)
  /KEEP=ID age Female STAI_trait pain_cat mindfulness cortisol_serum Time
  /NULL=KEEP.


* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Time MEAN(Pain)[name="MEAN_Pain"] PainVersion 
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Time=col(source(s), name("Time"), unit.category())
  DATA: MEAN_Pain=col(source(s), name("MEAN_Pain"))
  DATA: PainVersion=col(source(s), name("PainVersion"), unit.category())
  GUIDE: axis(dim(1), label("Time"))
  GUIDE: axis(dim(2), label("Mean Pain"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("PainVersion"))
  GUIDE: text.title(label("Multiple Line Mean of Pain by Time by PainVersion"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: line(position(Time*MEAN_Pain), color.interior(PainVersion), missing.wings())
END GPL.

SORT CASES  BY ID.
SPLIT FILE SEPARATE BY ID.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Time MEAN(Pain)[name="MEAN_Pain"] PainVersion 
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Time=col(source(s), name("Time"), unit.category())
  DATA: MEAN_Pain=col(source(s), name("MEAN_Pain"))
  DATA: PainVersion=col(source(s), name("PainVersion"), unit.category())
  GUIDE: axis(dim(1), label("Time"))
  GUIDE: axis(dim(2), label("Mean Pain"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("PainVersion"))
  GUIDE: text.title(label("Multiple Line Mean of Pain by Time by PainVersion"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: line(position(Time*MEAN_Pain), color.interior(PainVersion), missing.wings())
END GPL.

DATASET ACTIVATE DataSet4.
COMPUTE Time_cent=Time - 2.5.
EXECUTE.

COMPUTE Time_squared=Time_cent * Time_cent.
EXECUTE.


MIXED Pain WITH age Female STAI_trait pain_cat mindfulness cortisol_serum Time_cent Time_squared
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age Female STAI_trait pain_cat mindfulness cortisol_serum Time_cent Time_squared | 
    SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT Time_cent Time_squared | SUBJECT(ID) COVTYPE(UN)
  /SAVE=PRED.

VARSTOCASES
  /MAKE Pain FROM Pain PRED_Inter PRED_Slope PRED_Time_squared
  /INDEX=Pain_data(Pain) 
  /KEEP=ID age Female STAI_trait pain_cat mindfulness cortisol_serum Time Time_cent Time_squared 
  /NULL=KEEP.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Time MEAN(Pain)[name="MEAN_Pain"] Pain_data 
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Time=col(source(s), name("Time"))
  DATA: MEAN_Pain=col(source(s), name("MEAN_Pain"))
  DATA: Pain_data=col(source(s), name("Pain_data"), unit.category())
  GUIDE: axis(dim(1), label("Time"))
  GUIDE: axis(dim(2), label("Mean Pain"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("Pain_data"))
  GUIDE: text.title(label("Multiple Line Mean of Pain by Time by Pain_data"))
  ELEMENT: line(position(Time*MEAN_Pain), color.interior(Pain_data), missing.wings())
END GPL.

SORT CASES  BY ID.
SPLIT FILE SEPARATE BY ID.

DATASET ACTIVATE DataSet1.
* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Time Pain ID MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Time=col(source(s), name("Time"))
  DATA: Pain=col(source(s), name("Pain"))
  DATA: ID=col(source(s), name("ID"), unit.category())
  GUIDE: axis(dim(1), label("Time"))
  GUIDE: axis(dim(2), label("Pain"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("ID"))
  GUIDE: text.title(label("Multiple Line of Pain by Time by ID"))
  ELEMENT: line(position(Time*Pain), color.interior(ID), missing.wings())
END GPL.

MIXED Pain WITH age Female STAI_trait pain_cat mindfulness cortisol_serum Time_cent Time_squared
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age Female STAI_trait pain_cat mindfulness cortisol_serum Time_cent Time_squared | 
    SSTYPE(3)
  /METHOD=REML
  /RANDOM=INTERCEPT Time_cent Time_squared | SUBJECT(ID) COVTYPE(UN)
  /SAVE=RESID.

EXAMINE VARIABLES=RESID_1
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.


* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=PRED_Time_squared RESID_1 MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: PRED_Time_squared=col(source(s), name("PRED_Time_squared"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("Predicted Values"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by Predicted Values"))
  ELEMENT: point(position(PRED_Time_squared*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=age RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: age=col(source(s), name("age"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("age"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by age"))
  ELEMENT: point(position(age*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Female RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Female=col(source(s), name("Female"), unit.category())
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("Female"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by Female"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: point(position(Female*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=STAI_trait RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: STAI_trait=col(source(s), name("STAI_trait"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("STAI_trait"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by STAI_trait"))
  ELEMENT: point(position(STAI_trait*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=pain_cat RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: pain_cat=col(source(s), name("pain_cat"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("pain_cat"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by pain_cat"))
  ELEMENT: point(position(pain_cat*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mindfulness RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mindfulness=col(source(s), name("mindfulness"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("mindfulness"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by mindfulness"))
  ELEMENT: point(position(mindfulness*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=cortisol_serum RESID_1 MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: cortisol_serum=col(source(s), name("cortisol_serum"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("cortisol_serum"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by cortisol_serum"))
  ELEMENT: point(position(cortisol_serum*RESID_1))
END GPL.

COMPUTE Squared_resid=RESID_1 * RESID_1.
EXECUTE.

SPSSINC CREATE DUMMIES VARIABLE=ID 
ROOTNAME1=ID_dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Squared_resid
  /METHOD=ENTER ID_dummy_2 ID_dummy_3 ID_dummy_4 ID_dummy_5 ID_dummy_6 ID_dummy_7 ID_dummy_8 
    ID_dummy_9 ID_dummy_10 ID_dummy_11 ID_dummy_12 ID_dummy_13 ID_dummy_14 ID_dummy_15 ID_dummy_16 
    ID_dummy_17 ID_dummy_18 ID_dummy_19 ID_dummy_20.

CORRELATIONS
  /VARIABLES=age Female STAI_trait pain_cat mindfulness cortisol_serum Time_cent Time_squared
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
