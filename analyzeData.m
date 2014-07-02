function [ ] = analyzeData( fname1,fname2 )
%Analyzes data from files
%Inputs
%   fname: name of input file (string)

%% Read in files (f2d or txt)
a  = dlmread(fname1);
b  = dlmread(fname2);

%% Remove reflections from data, based on input params
% alpha=0.01;
% beta=0.000;
% thresh_slope=0.00001;

t_step=(a(5,1)-a(4,1));
Fs=1e15/t_step;

ts1=removeReflections2(a(:,1),a(:,2));
ts2=removeReflections2(b(:,1),b(:,2));

%% Get FFTs of time data

[YA,yvaluesA,fA,lambdaA]=FFTfunct(ts1,Fs,false);  %#ok<ASGLU>
[YB,yvaluesB,fB,lambdaB]=FFTfunct(ts2,Fs,false); %#ok<ASGLU>

%% Determine FWHM ratio to see how much bandwidth was lost compared to the input pulse (i.e. how much longer is the output pulse, varying with mesh density)

dataA=[transpose(lambdaA) yvaluesA];
dataB=[transpose(lambdaB) yvaluesB];

ycompA=max(dataA(:,2))/2;
ycompB=max(dataB(:,2))/2;

posA1 = 1;
posA2 = length(yvaluesA);
posB1 = 1;
posB2 = length(yvaluesB);


while dataA(posA1,2)<ycompA
    posA1 = posA1+1;
end

while dataA(posA2,2)<ycompA
    posA2 = posA2-1;
end

while dataB(posB1,2)<ycompB
    posB1 = posB1+1;
end

while dataB(posB2,2)<ycompB
    posB2 = posB2-1;
end

FWHMratio=(lambdaB(posB2)-lambdaB(posB1))/(lambdaA(posA2)-lambdaA(posA1));
fprintf('Ratio of FWHMs is %f\n\n',FWHMratio);

%% Determine ratio of output to input w/ frequency (i.e. desired coefficients)

figure()
subplot(2,1,1), plot(lambdaA,yvaluesA), title('FFT of a(t)'), xlabel('Wavelength (m)'), ylabel('|A(f)|');
subplot(2,1,2), plot(lambdaB,yvaluesB), title('FFT of b(t)'), xlabel('Wavelength (m)'), ylabel('|B(f)|');

ratio=comparisonRatio(yvaluesA,yvaluesB,lambdaA,lambdaB,'Transfer function (coupling)','Ratio','Wavelength (m)');

end

