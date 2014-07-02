function [ ratio ] = comparisonRatio( yvaluesA, yvaluesB, lambdaA, lambdaB, title1, ylabel1, xlabel1 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if length(lambdaA)<length(lambdaB)
   yshorter=yvaluesA(2:length(yvaluesA));
   ylonger=yvaluesB(2:length(yvaluesB));
   lambdashorter=lambdaA(2:length(lambdaA));
   lambdalonger=lambdaB(2:length(lambdaB));
   yspline_longer=transpose(interp1(lambdalonger,ylonger,lambdashorter,'spline'));
   ratio=yspline_longer./yshorter;
else
   ylonger=yvaluesA(2:length(yvaluesA));
   yshorter=yvaluesB(2:length(yvaluesB));
   lambdalonger=lambdaA(2:length(lambdaA));
   lambdashorter=lambdaB(2:length(lambdaB));
   yspline_longer=transpose(interp1(lambdalonger,ylonger,lambdashorter,'spline'));
   ratio=yshorter./yspline_longer;
end

figure()
plot(lambdashorter,ratio)
title(title1)
ylabel(ylabel1)
xlabel(xlabel1);
end

