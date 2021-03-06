function sum = Rana(x,y)
       sum = x*cos(sqrt(abs(y+x+1)))*sin(sqrt(abs(y-x+1)))+(1+y)*cos(sqrt(abs(y-x+1)))*sin(sqrt(abs(y+x+1)));
end