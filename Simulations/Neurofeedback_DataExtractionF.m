function [] = Neurofeedback_DataExtractionF(i, Caso)
%Extraction from structure to csv

MatrixSetpoint = out(i).Setpoint_Force;

MatrixChannel1Hemo = extractfNIRS(out(i).Channel1.signals.values)';
MatrixChannel2Hemo = extractfNIRS(out(i).Channel2.signals.values)';

MatrixChannel1fNIRS = extractfNIRS(out(i).fNIRS(:,1,:))';
MatrixChannel2fNIRS = extractfNIRS(out(i).fNIRS(:,2,:))';


%File creation
%Data file follows this order
% Time | fNIRS_ch1 | fNIRS_ch2 | Fuzzy | Pobs | HemoCh1 | HemoCh2 | Setpoint | 
%      |           |           |       |      |         |         |          |
%Error | dError |
%      |        |
ExperimentData = zeros(length(out(i).Time'), 14);
ExperimentData(:,1) = out.Time'; 
ExperimentData(:,2) = MatrixChannel1fNIRS(:, 1);
ExperimentData(:,3) = MatrixChannel1fNIRS(:, 2);
ExperimentData(:,4) = MatrixChannel2fNIRS(:, 1);
ExperimentData(:,5) = MatrixChannel2fNIRS(:, 2);

ExperimentData(:,6) = out(i).Fuzzy';
ExperimentData(:,7) = out(i).Pobs';
ExperimentData([1:length(MatrixChannel1Hemo)],8) = MatrixChannel1Hemo(:, 1);
ExperimentData([1:length(MatrixChannel1Hemo)],9) = MatrixChannel1Hemo(:, 2);
ExperimentData([1:length(MatrixChannel1Hemo)],10) = MatrixChannel2Hemo(:, 1);
ExperimentData([1:length(MatrixChannel1Hemo)],11) = MatrixChannel2Hemo(:, 2);
ExperimentData([1:length(MatrixSetpoint)],12) = MatrixSetpoint(:,1);
ExperimentData(:,13) = out(i).Errorfunction';
ExperimentData(:,14) = out(i).dErrorfunction';


ExperimentData = array2table(ExperimentData);
ExperimentData.Properties.VariableNames(1:14) = {'Time', 'fNIRSD1_ch1','fNIRSD2_ch1',...
                                                'fNIRSD1_ch2','fNIRSD2_ch2', 'Fuzzy', ...
                                                'Pobs', 'HemoCh1_DH', 'HemoCh1_DQ',...
                                                'HemoCh2_DH', 'HemoCh2_DQ', 'Setpoint', 'Error', 'dError'};

                            %Cambiar el nombre
i = int2str(i);
writetable(ExperimentData,"DataT/ExperimentData_" + Caso + i + ".csv");
end

