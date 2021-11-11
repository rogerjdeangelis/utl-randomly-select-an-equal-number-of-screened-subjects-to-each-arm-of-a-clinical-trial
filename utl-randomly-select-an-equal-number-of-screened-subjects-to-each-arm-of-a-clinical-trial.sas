%let pgm=utl-randomly-select-an-equal-number-of-screened-subjects-to-each-arm-of-a-clinical-trial;

Randomly select an equal number of screened subjects to each arm of a clinical trial

github
https://tinyurl.com/2uk7x28r
https://github.com/rogerjdeangelis/utl-randomly-select-an-equal-number-of-screened-subjects-to-each-arm-of-a-clinical-trial

StackOverFlow
https://tinyurl.com/hu3b56cm
https://stackoverflow.com/questions/68472685/how-to-keep-the-same-amount-of-people-based-on-a-column-in-sas-guide
Tom
https://stackoverflow.com/users/4965549/tom

There are other ways to do this but surveyselect will handle mutiple arms easily.

I have 19 subjects who have consented and passed screening.
Placebo and Aspirin has been randomly assigned to the 19 participants;

I need to create, randomly, a balanced design where I have the maximum
number of participants but the two treatments must have the same number
of subjects.

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

I need to create a balance design for a clinical trial of aspirin versus placebo.

data have;
  set sashelp.class;
  if uniform(3163)<.5 then trt="PLACEBO";
  else trt="ASPIRIN";
  keep name trt;
run;quit;

proc sort data=have out=havSrt;
by trt;
run;quit;

Up to 40 obs WORK.HAVSRT total obs=19 11NOV2021:16:00:03

Obs    NAME         TRT

  1    Barbara    ASPIRIN
  2    James      ASPIRIN
  3    Janet      ASPIRIN
  4    John       ASPIRIN
  5    Joyce      ASPIRIN
  6    Mary       ASPIRIN
  7    William    ASPIRIN

  8    Alfred     PLACEBO   Select 7 randomly from these 12
  9    Alice      PLACEBO
 10    Carol      PLACEBO
 11    Henry      PLACEBO
 12    Jane       PLACEBO
 13    Jeffrey    PLACEBO
 14    Judy       PLACEBO
 15    Louise     PLACEBO
 16    Philip     PLACEBO
 17    Robert     PLACEBO
 18    Ronald     PLACEBO
 19    Thomas     PLACEBO

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

Up to 40 obs WORK.WANT total obs=14 11NOV2021:16:03:34

Obs      TRT      NAME

  1    ASPIRIN    Barbara    7 subjects
  2    ASPIRIN    James
  3    ASPIRIN    Janet
  4    ASPIRIN    John
  5    ASPIRIN    Joyce
  6    ASPIRIN    Mary
  7    ASPIRIN    William

  8    PLACEBO    Alice      7 subjects
  9    PLACEBO    Carol
 10    PLACEBO    Jane
 11    PLACEBO    Jeffrey
 12    PLACEBO    Louise
 13    PLACEBO    Ronald
 14    PLACEBO    Thomas

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

* Get the arm with the least subjects;
proc sql noprint;
   select
      min(count) into :size trimmed
   from (
         select
              trt
             ,count(*) as count
         from
              havSrt
         group
              by trt
        )
;
quit;

%put &=size;
/* size=7 */

* randomly select 7 subjects from the 12 in PLACEBO;
proc surveyselect data=havSrt n=&size seed=47279 out=want(drop=s:);
  strata trt;
run;

