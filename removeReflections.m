function [ ts ] = removeReflections( t_vals,pulse,t_step,thresh_slope,alpha,beta )
%removeReflections: removes data from any stray reflections
%Inputs
%   t_vals: set of time values extracted from first column of data file (w/ constant time difference)
%   t_step: said constant time difference in values
%   pulse: set of associate pulse amplitude values from second column of data file

%   thresh_slope: maximum abs. value of slope at a data point to distinguish between peak and non-peak values (ideally, slope of 0 at peak)
%   alpha: constant (fraction <1) to choose peak values at start/end of pulse (i.e. where abs(peak_pulse_value)<alpha*max_pulse_value)
%   beta: constant (fraction <1) to discard peak values (~0, <beta*max_pulse) not in the time between original pulse and reflection (i.e. where abs(peak_pulse_value)>beta*max_pulse_value)

%Ouputs
%   ts: time series pulse amplitude values, w/o reflections

%% NEED to fix problems of:
% a) not updating input parameters after some number of iterations (x)
% b) not allowing for continuing (e.g. continously thinking bad input params chosen)

%% Note: enter 1/0 for all true/false questions (e.g. "Satisfied... ?")
%%

cont=0;
iter=1;

change_alpha=1;
change_beta=1;
change_thresh_slope=1;
in_error=0;

while (~cont==1)

fprintf('------Iteration number %g---------\n\n',iter);    

if iter~=1
    
    if (~in_error)
    str_result=input('Change which of (alpha,beta,thesh-slope)? : ','s');
    change_alpha=str2num(str_result(1));
    change_beta=str2num(str_result(2));
    change_thresh_slope=str2num(str_result(3));
    end
    
    if change_alpha==1
        alpha=input('New value of alpha: ');
    end
    if change_beta==1
        beta=input('New value of beta: ');
    end
    if change_thresh_slope==1
        thresh_slope=input('New value of threshold slope: ');
    end
end

in_error=0;
change_alpha=1;
change_beta=1;
change_thresh_slope=1;

[max_val max_ind] = max(pulse);

%%
dy=abs(gradient(pulse,t_step));
%%
j=1;
for i=1:length(pulse)
    if dy(i)<thresh_slope
        peak_index(j)=i;
        j=j+1;
    end
end

figure(),plot(t_vals,pulse,'.',t_vals(peak_index),pulse(peak_index),'r.');

if peak_index(length(peak_index))<max_ind(1);
    fprintf('Bad value of theshold slope. Only %g data points left. Restarting... \n',length(peak_index));
    change_alpha=0;change_beta=0;
    in_error=1;
    cont=0;iter=iter+1;
    continue;
end
%%
k=1;
for i=1:length(peak_index)
    if (abs(pulse(peak_index(i)))<alpha*max(pulse) && abs(pulse(peak_index(i)))>beta*max(pulse))
        off_index(k)=peak_index(i);
        k=k+1;
    end
end

figure(),plot(t_vals(peak_index),pulse(peak_index),'r.',t_vals(off_index),pulse(off_index),'g.');

if off_index(length(off_index))<max_ind(1);
    fprintf('Bad value of alpha or beta. Only %g data points left. Restarting... \n',length(off_index));
    change_thresh_slope=0;
    in_error=1;
    cont=0; iter=iter+1;
    continue;
end
%figure(),plot(t_vals,pulse,'.',t_vals(off_index),abs(pulse(off_index)),'r.');
%%
m=1;
for i=1:(length(off_index)-1)
   grad_peaks(m)=(abs(pulse(off_index(i+1)))-abs(pulse(off_index(i))))/(t_vals(off_index(i+1))-t_vals(off_index(i)));
   m=m+1;
end
%%
i=1;

while (sign(grad_peaks(i))~=-1)
    i=i+1;
    if i>length(grad_peaks)
        break;
    end
end

% x=t_vals(off_index(1:length(grad_peaks)));
% plot(x,grad_peaks);
% Y = sign(grad_peaks).*log10(abs(c));
% figure
% plot(x,Y,'.')
% yl = get(gca,'ytick');
% set(gca,'yticklabel',sign(yl).*10.^abs(yl));

first_end_index=i; %% Index in grad_peaks where sign(grad_index)=-1 or length(grad_peaks)+1
%%
reflected_start_ind=0;
for i=first_end_index:length(grad_peaks)
    if i==(length(grad_peaks)+1)
       reflected_start_ind=off_index(i);
       break;
    end
    if sign(grad_peaks(i))==1
       reflected_start_ind=off_index(i);
       break;
    end
end

%%
%%
ts=pulse(1:reflected_start_ind);

if reflected_start_ind>max_ind(1) 
figure('Name',strcat('alpha=',num2str(alpha),', beta=',num2str(beta), ' thresh-slope=',num2str(thresh_slope)))
subplot(1,2,1), plot(t_vals,pulse), title('Original data')
subplot(1,2,2), plot(t_vals(1:reflected_start_ind),ts), title('Removed reflections')

cont=input('Satisfied with how much reflection data has been removed? ');
else
    cont=0;
end
%%
iter=iter+1;

end

end