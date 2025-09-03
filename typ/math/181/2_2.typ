= Limits of Functions
\
Suppose $f(x)$ is defined on an interval everywhere except at $x = c$.
\
\
If $f(x)$ is arbitrarily close to $L$, for all $x$ sufficiently close
to $c$, we write:
$
lim_(x -> c)(f(x) = L)
$

#h(1cm) *Example 1*:
$
lim_(x -> 1)(f((x^2-1)/(x-1)) = 2)
$
\

#h(1cm) *Example 2*:
\
\
#h(1cm ) The limit does not depend on how the function is defined at the point
being approached

#set align(center) 
#image("./assets/lim_func_values.png", width: 70%)
#set align(left) 
\

#h(1cm) *Example 2*:
\
\
#h(1cm ) If $f$ is the identity function: $f(x) = x$, then for any $c$, being approached:
$
lim_(x->c)(f(x)) = lim_(x->c)(x) = c
$

#h(1cm) *Example 3*:
\
\
#h(1cm) If $f$ is a constant functfion: $f(x)=k$, then for any $c$, $lim_(x->c)(k) = k$
#set align(center) 
#image("./assets/lim_dne.png", width: 70%)
#set align(left) 
\

== Limit Laws
\
#set align(center) 
#image("./assets/lim_laws.png", width: 70%)
#set align(left) 
\
#h(1cm) *Example 4*:
\
$
lim_(x->c)(x^3+4x^2-3) = c^3+4c^2-3
$
\
$
lim_(x->c)((x^4+4x^2-1)/(x^2+5)) = (c^4+4c^2-1)/(c^2+5)
$
\
$
lim_(x->c)(sqrt(4x^2-3)) = sqrt(4(-2)^2-3) = sqrt(16-3) = sqrt(13)
$
\
#h(1cm) *Example 5*:
\
$
lim_(x->-1)((x^3+4x^2-3)/(x^2+5)) = (-1+4-3)/(1+5) = 0/6 = 0
$

#h(1cm) *Example 6*:
\
$
lim_(x->-1)((x^2+x-2)/(x^2-x)) = (1+1-2)/(1-1) = 0/0 " INDETERMINATE"
\
\
"INSTEAD (FOR RATIONAL FUNCTIONS):"
\
\
lim_(x->-1)((x^2+x-2)/(x^2-x)) = ((x+2)(x-1))/(x(x-1)) = 3/1 = 3
$
\

== The Sandwich Theorem
\
#set align(center) 
#image("./assets/sandwich.png", width: 70%)
#set align(left) 
\
When $g(x) <= f(x) <= h(x)$, for all $x$ in some intercval containing $c$,
except possibly at $x=c$ itself. Suppose also that:
\
$
lim_(x->c)g(x) = lim_(x->c)h(x) = L
$
\
The $lim_(x->c)f(x) = L$.
\
#set align(center) 
#image("./assets/sandwich_2.png", width: 70%)
#set align(left) 
\

#h(1cm) *Example 7*:
\
#set align(center) 
#image("./assets/sandwich_3.png", width: 70%)
#set align(left) 
\

*Theorem 5*
\
#set align(center) 
#image("./assets/sandwich_4.png", width: 70%)
#set align(left) 
\
