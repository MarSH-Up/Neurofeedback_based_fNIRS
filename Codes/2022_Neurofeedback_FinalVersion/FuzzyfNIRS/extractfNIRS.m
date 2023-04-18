function [Matrix] = extractfNIRS(Channel)

Matrix = zeros(2,length(Channel(:,1,:)));
for i = 1:length(Channel(:,1,:))
    Matrix(:,i) = Channel(:,1,i);
end

