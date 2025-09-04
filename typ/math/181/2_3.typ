#set text(12pt, font: "" )
#let date = datetime(
  year: 2025,
  month: 9,
  day: 4
)

#set align(center) 
#pad(top: 4cm, bottom: 1.5cm, [
  = 2; Limits & Continuity Cont.

  #v(10pt)
  #set text(14pt, style: "normal")
  Gael Zarco

  #date.display("[month repr:long] [day], [year]")
])

#set align(center)
  #image("./assets/bounds.png", width: 90%)
#set align(left) 

#set align(left) 
*Example 1*

Consider the line $y=2x-1$ near $x=4$, how close to $x=4$ does $x$ have to be so
that $y=2x+1$ differs from $7$ by less than $2$ units?

*Hint*

Recall one-dimensional distance from $a$ to $b$ is $|b-a|$.

*Solution*

$
|y-7|=|2x-1-7|
$

$
|y-7|=|2x-8|
$

$
|y-7|=|2x-8| < 2
$

$
|y-7|=|2x-8| < 2
$

#set align(center) 
Take $|2x-8| < 2$ and solve linear inequality.
#set align(left) 

$
|2x-8| < 2
$

$
-2 < 2x-8 < 2
$

$
6 < 2x < 10
$

$
3 < x < 5 
$

#set align(center)
  #image("./assets/bounds_2.png", width: 90%)
#set align(left) 

#set align(center)
  #image("./assets/bounds_3.png", width: 90%)
#set align(left) 

*Example 2*

Show $lim_(x->1) 5x-3 = 2$

*Hint*

$c=1$, $f(x)=5x-3$, $L=2$ for any $epsilon > 0$ we must find $delta > 0$ (in
terms of $epsilon$).

When $|x-1|<delta$ => $|f(x)-2|<epsilon$

*Solution*

$
|5x-3-2| < epsilon
$

$
|5x-5| < epsilon
$

$
5|x-1| < epsilon
$

$
|x-1| < epsilon/5
$

Choose $delta = epsilon/5$.

i.e. if you want to be within $5$ of $L$, choose $delta = 5/5 = 1$.

When $x$ is in $(0,2)$, $y$ is in $(-3,7)$

*Example 3*

(a) Prove $lim_(x->c)x=c$

We want whenever $|x-c| < delta$ => $|f(x)-L|<epsilon$

$|x-c|<epsilon$ so choose $delta=epsilon$.

(b) Show $lim_(x->c)k=k$

Whenever $|x-c|<delta$ => $|k-k|<epsilon$

So $|x-c|<delta$ when $epsilon>0$, i.e. $delta$ can be any positive number.

#set align(center)
  #image("./assets/bounds_4.png", width: 90%)
#set align(left) 
_Example 3.b Figure 1_

*Example 4*

For $lim_(x->5)sqrt(x-1)=2$ find $delta>0$ such that $epsilon=1$.

Whenever $|x-5|<delta$ => $|sqrt(x-1)-2|<1$

$
|sqrt(x-1)-2|<1
$

$
-1<sqrt(x-1)-2<1
$

$
1<sqrt(x-1)<3
$

$
1<x-1<9
$

$
2<x<10
$

#set align(center)
  #image("./assets/bounds_5.png", width: 90%)
#set align(left) 
_Example 4; Figure 2_

#set align(center)
  #image("./assets/bounds_6.png", width: 90%)
#set align(left) 
_Steps to Find $delta$ Algebraically; Figure 3_

#set align(center)
  #image("./assets/bounds_7.png", width: 90%)
#set align(left) 
_Example 6; Figure 4_

#set align(center)
  #image("./assets/bounds_8.png", width: 90%)
#set align(left) 
_Example 6 Cont.; Figure 5_
