% Polyfit:  Fits a polynomial of degree P to 1D data variables x and y.
%       P: Polynomial degree
%       x: Traing data x
%       y: Training data y
%
%       B: Coeficients betha of the polynomial fit
%       e: Sum of squared erros of the fit

function [B, X] = Polyfit(P, x, y)
    
    %Number of training objects
    N = length(x);
    %Initializes the design matrix
    X = ones(N,P+1);
    
    %Input verification
    if(P<1)
        disp('Order not valid')
        return;
    end
    if(N~= length(y))
        disp('Error in training data') 
        return;
    end
    
    %Assigns x^i to the colum i of the design matrix
    for i=1:1:(P+1)
       X(:,i)=x.^(i-1);
    end
    
    %Estimates the parameters B
    B = pinv(X)*y;
    
    %Computes the sum of the squared errors
    prod = X*B;

    e= y-prod;
    e= e'*e;

end