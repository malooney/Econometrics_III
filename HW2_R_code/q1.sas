proc import out=multinomial
datafile= "C:\Users\che14546\Desktop\metric hw2\multinomial.xlsx"
dbms=excel replace;
run;

/*multinomial logit*/
proc logistic data=multinomial;
class choice(ref="1")/param=reference;
model choice =income size race/link=glogit;
run;
 
proc import out=conditional
datafile= "C:\Users\che14546\Desktop\metric hw2\conditional.xlsx"
dbms=excel replace;
run;

/*conditional logit*/
proc mdc data=conditional;
model choice=price d1 d2 d3 d4 d5 d6 d7 d8/type=clogit nchoice=8;
id id;
run;

/*mixed logit*/
proc import out=mixed
datafile="C:\Users\che14546\Desktop\nimanthika data set\mixed.xlsx"
dbms=excel replace;
run;

data mixed;
set mixed;
d1inc=d1*income;
d2inc=d2*income;
d3inc=d3*income;
d4inc=d4*income;
d5inc=d5*income;
d6inc=d6*income;
d7inc=d7*income;
d8inc=d8*income;

d1size=d1*size;
d2size=d2*size;
d3size=d3*size;
d4size=d4*size;
d5size=d5*size;
d6size=d6*size;
d7size=d7*size;
d8size=d8*size;

d1race=d1*race;
d2race=d2*race;
d3race=d3*race;
d4race=d4*race;
d5race=d5*race;
d6race=d6*race;
d7race=d7*race;
d8race=d8*race;
run;


proc mdc data=mixed;
model choice=d1inc d2inc d3inc d3inc d5inc d6inc d7inc 
             d1size d2size d3size d4size d5size d6size d7size
			 d1race d2race d3race d4race d5race d6race d7race 
			 price_cl/type=mixedlogit nchoice=8;
ID id;
run;

/*nested model*/
proc import out=nested
datafile="C:\Users\che14546\Desktop\metric hw2\nested.xlsx"
dbms=excel replace;
run;

proc mdc data=nested;
model choice=price c6 c7 /type=nestedlogit choice=(c 6 7 8,brchcl 1 2 3 4 5 6 7 8);
id id;
utility u(1,1 2 3@6)=price,
        u(1,4 5 @7)=price,
		u(1,6 7 8@8)=price,
		u(2,6 7 8)=c6 c7 ;
		run;

