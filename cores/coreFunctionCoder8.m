function code = coreFunctionCoder8(string,modulation_level,length)
    ascii_code = int8(string);
    bits = false(1,8*numel(ascii_code));
    for i = 1:numel(ascii_code)
        bits(8*i+(-7:0)) = de2bi(ascii_code(i),8,'left-msb').';
    end
    bits_padded = [bits false(1,modulation_level*length-numel(bits))];
    binary_seed = reshape(bits_padded,modulation_level,length);
    deciaml_seed = bi2de(binary_seed.').';
    code = qammod(deciaml_seed,2^modulation_level,'UnitAveragePower',true);
end