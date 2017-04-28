%open directory containing trace files
trace_dir = dir('../CSV_2k/*.csv');
%define number of files being used
%200 files: 14min 06 seconds
num_files = 250;

%allocate memory for data matrices
p_matrix = zeros(num_files, 1);
hd_matrix = zeros(num_files, 64, 1);

%for each trace file
disp('Generating tracefile data...');
for i = 1:num_files
    fprintf('Trace %i...', i);
    trace = csvread(strcat('../CSV_2k/',trace_dir(i).name));
    %get maximum power for round 1
    trace_msg = strsplit(trace_dir(i).name, 'm=');
    trace_msg = char(trace_msg(2));
    trace_msg = strsplit(trace_msg, '_');
    trace_msg = char(trace_msg(1));
    p_matrix(i, 1) = max(trace(5725:5775, 2));
    %for each sbox combo for this message
    for j=1:8
        hd_matrix(i, :, j) = DES(hex2bi(trace_msg), 'ENC', j);
    end
    disp('done');
end

%when all tracefiles have been read, generate correlation coefficient
disp('Generating correlation matrix data...');
cor_coef = zeros(64, 8);
vals = zeros(8, 2);
for i=1:8
    cor_coef(:, i) = corr(p_matrix(:, 1), hd_matrix(:, :, i));
    plot(1:64, cor_coef(:, i)), hold on
    [val, ind] = max(cor_coef(:, i));
    vals(i, 1) = val;
    vals(i, 2) = ind;
end
disp('done');

%[val, ind] = max(cor_coef:, 1)












