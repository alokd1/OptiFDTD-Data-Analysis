close all
clear all

%Reading in the data . You will need to delete the first few lines of the fdtd output 
%before you use dlmread function. You can use a simple text viewer to look
%at the contents

A  = dlmread('ObservationPoint_1.f2d');
B  = dlmread('ObservationPoint_10.f2d');
%C  = dlmread('crossing_ObservationPoint_3_EyFFT.f2d');
%D  = dlmread('crossing_ObservationPoint_4_EyFFT.f2d');
%plotting raw data
figure(1)
ratio = B(:,2)./A(:,2);
ni = 640;
nf = 690;
plot(A(ni:nf,1),B(ni:nf,2)./A(ni:nf,2))
% plot(ratio(600:-1:500))

%Raw data is a bit noisy so I used a filter to clean it up
%g = gausswin(20); % <-- this value determines the width of the smoothing window
%g = g/sum(g);
%Asm = conv(A(:,2), g, 'same');
%Bsm = conv(B(:,2), g, 'same');
%Csm = conv(C(:,2), g, 'same');
%Dsm = conv(D(:,2), g, 'same');

%plotting the coupling coefficient
% ni = 1;
% nf = 100;
% lam = 59.95e3*A(ni:nf,1)/(max(A(:,1)));
% figure(2)
% plot(lam,Bsm(ni:nf,1)./Asm(ni:nf,1),lam,Dsm(ni:nf,1)./Asm(ni:nf,1));
% axis([900 2000 0 1])
% xlabel('Wavelength (nm)')
% ylabel('C')
% legend('Coupling Coeff 1','Coupling Coeff 2')
% figure(2)
% ratio = B(:,2)./A(:,2);
% plot(A(:,1),ratio)