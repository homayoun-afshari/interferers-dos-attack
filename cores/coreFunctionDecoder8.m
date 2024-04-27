function string = coreFunctionDecoder8(code,modulation_level,length)
    code(isnan(code)) = 0;
    deciaml_seed = qamdemod(code,2^modulation_level,'UnitAveragePower',true);
    binary_seed = de2bi(deciaml_seed,modulation_level).';
    bits = reshape(binary_seed,1,numel(binary_seed));
%     length = floor(numel(code)*modulation_level/8);
    ascii_code = zeros(1,length,'uint8');
    for i = 1:min(floor(modulation_level*numel(code)/8),length)
        ascii_code(i) = bi2de(bits(8*i+(-7:0)),'left-msb').';
    end
    string = char(ascii_code);
end