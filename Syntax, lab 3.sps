* Encoding: UTF-8.

DATASET ACTIVATE DataSet1.
RECODE Sex ('female'='0') ('male'='1').
EXECUTE.


RECODE Parch (0 thru 1=0) (ELSE=1) INTO ParchRecode.
EXECUTE.


RECODE Age (0 thru 15=1) (16 thru 30=2) (31 thru 45=3) (46 thru Highest=4) INTO AgeCat.
EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE Pclass (2=1) (ELSE=0) INTO Class2.
EXECUTE.

RECODE Pclass (3=1) (ELSE=0) INTO Class3.
EXECUTE.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Survived COUNT()[name="COUNT"] AgeCat 
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Survived=col(source(s), name("Survived"), unit.category())
  DATA: COUNT=col(source(s), name("COUNT"))
  DATA: AgeCat=col(source(s), name("AgeCat"), unit.category())
  GUIDE: axis(dim(1), label("Survived"))
  GUIDE: axis(dim(2), label("Count"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("AgeCat"))
  GUIDE: text.title(label("Stacked Bar Count of Survived by AgeCat"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval.stack(position(Survived*COUNT), color.interior(AgeCat), 
    shape.interior(shape.square))
END GPL.

COMPUTE ChildOnlyOneParent=(ParchRecode <= 1) + (AgeCat = 1).
EXECUTE.

RECODE ChildOnlyOneParent (1=0) (2=1).
EXECUTE.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Age Survived MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Age=col(source(s), name("Age"))
  DATA: Survived=col(source(s), name("Survived"), unit.category())
  GUIDE: axis(dim(1), label("Age"))
  GUIDE: axis(dim(2), label("Frequency"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("Survived"))
  GUIDE: text.title(label("Stacked Bar of Age by Survived"))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  ELEMENT: interval.stack(position(summary.count(bin.rect(Age))), color.interior(Survived), 
    shape.interior(shape.square))
END GPL.




NOMREG Survived (BASE=FIRST ORDER=ASCENDING) WITH Age Sex Class2 Class3 NoCabin SibSpRecode 
    ParchRecode
  /CRITERIA CIN(95) DELTA(0) MXITER(100) MXSTEP(5) CHKSEP(20) LCONVERGE(0) PCONVERGE(0.000001) 
    SINGULAR(0.00000001) 
  /MODEL
  /STEPWISE=PIN(.05) POUT(0.1) MINEFFECT(0) RULE(SINGLE) ENTRYMETHOD(LR) REMOVALMETHOD(LR)
  /INTERCEPT=INCLUDE
  /PRINT=CLASSTABLE FIT PARAMETER SUMMARY LRT CPS STEP MFI IC.
